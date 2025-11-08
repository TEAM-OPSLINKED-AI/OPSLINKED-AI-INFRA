import os
import json
import httpx
from fastapi import FastAPI, HTTPException, BackgroundTasks
from pydantic import BaseModel
from typing import Optional, Dict, Any

# --- 환경 변수 설정 ---
# 1. 배포된 LLaMA (llama-cpp-python) 서버 주소
LLAMA_SERVER_URL = os.getenv("LLAMA_SERVER_URL", "http://localhost:8000/v1/chat/completions")

# 2. Go로 작성된 Remediation Module 주소 (사용자 로그 기준)
REMEDIATION_MODULE_URL = os.getenv("REMEDIATION_MODULE_URL", "http://172.20.112.101:32563/remediate")

# --- FastAPI 앱 초기화 ---
app = FastAPI(
    title="OpsLinked-AI Bridge Server",
    description="Receives alerts, queries LLaMA, and triggers remediation actions."
)

# --- Pydantic 모델 정의 ---

class AlertPayload(BaseModel):
    """
    이 FastAPI 서버가 /analyze-and-remediate 엔드포인트로 받을 입력
    """
    description: str              # 예: "A Spring Boot application's JVM heap memory usage..."
    namespace: str = "default"
    resourceName: str             # 예: "wwwm-spring-dummy" 또는 "k8s-worker-1"
    parameters: Optional[Dict[str, Any]] = None # EXECUTE_NODE_SHELL_COMMAND용 (예: {"logPath": ...})
    triggeredBy: str = "AI-Bridge-Server"

class LlmResponse(BaseModel):
    """
    LLaMA 모델의 응답에서 파싱할 JSON 객체
    """
    analyze: str
    solution: str
    scenario_id: str

# --- 시스템 프롬프트 (QA Set의 instruction과 동일) ---
SYSTEM_PROMPT = """You are an AI SRE specializing in Kubernetes infrastructure. Analyze why this situation occurred, create an output for automated action, and identify the corresponding scenario and the required remediation. Respond *only* with a valid JSON object in the format {"analyze": "...", "solution": "...", "scenario_id": "..."}."""


# --- 비동기 헬퍼 함수 ---

async def query_llama_model(description: str, client: httpx.AsyncClient) -> LlmResponse:
    """
    LLaMA 서버에 분석을 요청하고 JSON 응답을 파싱합니다.
    """
    llama_request_payload = {
        "model": "local-model", # llama-cpp-python 서버는 로드된 모델을 사용하므로 이름은 중요하지 않음
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": description}
        ],
        "response_format": {"type": "json_object"}, # JSON 응답 강제
        "temperature": 0.0
    }
    
    try:
        # --- [수정됨] ---
        # LLaMA 모델 응답 시간이 길 수 있으므로 타임아웃을 300초(5분)로 늘립니다.
        response = await client.post(LLAMA_SERVER_URL, json=llama_request_payload, timeout=300.0)
        
        response.raise_for_status() # 4xx 또는 5xx 응답 시 예외 발생
        
        # OpenAI 호환 응답에서 JSON 문자열 추출
        content_str = response.json()["choices"][0]["message"]["content"]
        llm_data = json.loads(content_str)
        
        return LlmResponse(**llm_data)
        
    except httpx.TimeoutException as e:
        print(f"Error: LLaMA server query timed out after 300 seconds: {e}")
        raise HTTPException(status_code=504, detail=f"LLaMA server request timed out: {e}")
    except httpx.RequestError as e:
        print(f"Error querying LLaMA server: {e}")
        raise HTTPException(status_code=503, detail=f"LLaMA server request failed: {e}")
    except (json.JSONDecodeError, KeyError, IndexError) as e:
        print(f"Error parsing LLaMA response: {e}. Response: {response.text}")
        raise HTTPException(status_code=500, detail="Failed to parse LLaMA model response.")

async def trigger_remediation(payload: Dict[str, Any], client: httpx.AsyncClient):
    """
    Go Remediation 모듈에 최종 조치 명령을 보냅니다.
    """
    try:
        # 조치 모듈 타임아웃은 60초로 설정
        response = await client.post(REMEDIATION_MODULE_URL, json=payload, timeout=60.0)
        response.raise_for_status()
        print(f"Successfully triggered remediation: {payload.get('actionType')}")
        return response.json()
        
    except httpx.RequestError as e:
        print(f"Error triggering remediation: {e}")
    except Exception as e:
        print(f"An unexpected error occurred during remediation: {e}")


# --- API 엔드포인트 ---

@app.post("/analyze-and-remediate")
async def analyze_and_remediate(alert: AlertPayload, background_tasks: BackgroundTasks):
    """
    알림을 받아 LLaMA로 분석 후, 조건에 맞는 시나리오(1.3, 2.1, 3.5)에 대해
    자동 조치를 비동기적으로 실행합니다.
    """
    async with httpx.AsyncClient() as client:
        # 1. LLaMA 모델에 분석 요청
        try:
            llm_response = await query_llama_model(alert.description, client)
        except HTTPException as e:
            # LLaMA 쿼리 실패 시, 클라이언트에게 즉시 에러 반환
            return {"status": "error", "detail": e.detail, "scenario_id": None}

        remediation_payload = None
        
        # 2. LLaMA 응답(scenario_id)을 기반으로 조치 페이로드 생성
        if llm_response.scenario_id in ("1.3", "3.5"):
            # 시나리오 1.3: JVM Heap Pressure
            # 시나리오 3.5: DB Connection Pool Exhaustion
            remediation_payload = {
                "actionType": "RESTART_DEPLOYMENT",
                "namespace": alert.namespace,
                "resourceName": alert.resourceName,
                "reason": f"AI Analysis ({llm_response.scenario_id}): {llm_response.analyze}",
                "triggeredBy": alert.triggeredBy
            }
            
        elif llm_response.scenario_id == "2.1":
            # 시나리오 2.1: Log Rotation
            if not alert.parameters or 'logPath' not in alert.parameters:
                # 이 시나리오는 logPath 파라미터가 필수임
                detail = "Scenario 2.1 (Log Rotation) identified, but 'parameters.logPath' was missing in the request."
                print(f"Skipping remediation: {detail}")
                return {"status": "skipped", "llm_response": llm_response, "detail": detail}
                
            remediation_payload = {
                "actionType": "EXECUTE_NODE_SHELL_COMMAND",
                "resourceName": alert.resourceName, # 이 경우 resourceName은 노드 이름이어야 함
                "parameters": alert.parameters,
                "reason": f"AI Analysis ({llm_response.scenario_id}): {llm_response.analyze}",
                "triggeredBy": alert.triggeredBy
            }

        # 3. 조치 실행 (백그라운드)
        if remediation_payload:
            # 조치 실행은 오래 걸릴 수 있으므로 백그라운드 작업으로 넘김
            background_tasks.add_task(trigger_remediation, remediation_payload, client)
            
            # 클라이언트에게는 즉시 응답 반환
            return {
                "status": "accepted",
                "action_triggered": remediation_payload.get("actionType"),
                "llm_response": llm_response
            }
        else:
            # LLaMA가 분석은 했으나, 3가지 시나리오에 해당하지 않는 경우
            return {
                "status": "analyzed_only",
                "action_triggered": None,
                "llm_response": llm_response,
                "detail": "LLaMA analysis complete, but no matching remediation action configured for this scenario_id."
            }

if __name__ == "__main__":
    import uvicorn
    # 테스트용: uvicorn main:app --reload --port 8081
    uvicorn.run(app, host="0.0.0.0", port=8081)