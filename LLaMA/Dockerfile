# 1. Python 3.10-slim을 기본 이미지로 사용
FROM python:3.10-slim

# 2. 빌드 시 인자로 받을 모델 정보
ARG LLM_HF_REPO_ID="QuantFactory/Meta-Llama-3-8B-Instruct-GGUF"
ARG LLM_HF_FILE="Meta-Llama-3-8B-Instruct.Q4_K_M.gguf"

# 3. 환경 변수 설정
ENV HF_REPO_ID=${LLM_HF_REPO_ID}
ENV HF_FILE=${HF_FILE}

# 4. 작업 디렉토리 설정
WORKDIR /app

# 5. (Changed) C/C++ 컴파일러 및 빌드 도구 설치
# python:3.10-slim 이미지에는 빌드 도구가 빠져있어 명시적으로 설치해야 합니다.
RUN apt-get update && apt-get install -y build-essential cmake

# 6. 필수 패키지 설치
#    llama-cpp-python[server]: CPU 추론 및 API 서버 기능 포함
#    huggingface-hub: 모델 다운로드용
RUN pip install --no-cache-dir llama-cpp-python[server] huggingface-hub

# 7. 모델 다운로드
RUN huggingface-cli download \
    ${HF_REPO_ID} \
    ${HF_FILE} \
    --local-dir /app/models \
    --local-dir-use-symlinks False

# 8. API 서버 포트 노출
EXPOSE 8000

# 9. 컨테이너 실행 명령 (CMD)
CMD ["python3", "-m", "llama_cpp.server", \
     "--model", "/app/models/${HF_FILE}", \
     "--n_gpu_layers", "0", \
     "--host", "0.0.0.0", \
     "--port", "8000"]