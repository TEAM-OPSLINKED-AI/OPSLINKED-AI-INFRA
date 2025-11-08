# 1. 기본 이미지
FROM python:3.10-slim

# 2. 작업 디렉토리 설정
WORKDIR /app

# 3. 의존성 파일 복사 및 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. 애플리케이션 코드 복사
COPY main.py .

# 5. FastAPI 서버 포트 노출
EXPOSE 8081

# 6. 컨테이너 실행 명령 (CMD)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8081"]