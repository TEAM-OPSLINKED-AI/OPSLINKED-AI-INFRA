# 1. Python 3.10-slim을 기본 이미지로 사용
FROM python:3.10-slim

# 2. 빌드 시 인자로 받을 모델 정보
ARG LLM_HF_REPO_ID="QuantFactory/Meta-Llama-3-8B-Instruct-GGUF"
ARG LLM_HF_FILE="Meta-Llama-3-8B-Instruct.Q4_K_M.gguf"

# 3. 환경 변수 설정
ENV HF_REPO_ID=${LLM_HF_REPO_ID}
ENV HF_FILE=${LLM_HF_FILE}

# 4. 작업 디렉토리 설정
WORKDIR /app

# 5. C/C++ 컴파일러 및 빌드 도구 설치
RUN apt-get update && apt-get install -y build-essential cmake

# 6. 필수 패키지 설치
RUN pip install --no-cache-dir llama-cpp-python[server] huggingface-hub

# 7. 모델 다운로드
RUN python3 -c "from huggingface_hub import hf_hub_download; import os; hf_hub_download(repo_id=os.environ['HF_REPO_ID'], filename=os.environ['HF_FILE'], local_dir='/app/models', local_dir_use_symlinks=False)"

# 8. API 서버 포트 노출
EXPOSE 8000

# 9. 컨테이너 실행 명령 (CMD)
#    환경 변수(${HF_FILE}) 치환을 위해 /bin/sh -c (shell form) 사용
CMD ["/bin/sh", "-c", "python3 -m llama_cpp.server --model /app/models/${HF_FILE} --n_gpu_layers 0 --host 0.0.0.0 --port 8000"]