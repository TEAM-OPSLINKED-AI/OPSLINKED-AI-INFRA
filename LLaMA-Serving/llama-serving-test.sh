docker run -d \
  --name llama3-serving \
  -p 8081:8081 \
  -e LLAMA_SERVER_URL="http://host.docker.internal:8080/v1/chat/completions" \
  -e REMEDIATION_MODULE_URL="http://<K8s Host IP>:32563/remediate" \
  --add-host=host.docker.internal:host-gateway \
  --restart unless-stopped \
  judemin/llama3-serving:latest

### Test request
curl -X POST http://<Compute2 Host IP>:8081/analyze-and-remediate \
-H "Content-Type: application/json" \
-d '{
    "description": "A Spring Boot application''s JVM heap memory usage is approaching its maximum limit, signaling a potential memory leak or an impending OOM event.",
    "namespace": "default",
    "resourceName": "wwwm-spring-dummy",
    "triggeredBy": "Simulation-CURL-1.3"
}'

curl -X POST http://<Compute2 Host IP>:8081/analyze-and-remediate \
-H "Content-Type: application/json" \
-d '{
    "description": "A node''s root filesystem is running out of space due to an application''s log file growing indefinitely.",
    "namespace": "default",
    "resourceName": "k8s-worker-1",
    "parameters": {
        "logPath": "/var/log/test-app/app.log"
    },
    "triggeredBy": "Simulation-CURL-2.1"
}'

curl -X POST http://<Compute2 Host IP>:8081/analyze-and-remediate \
-H "Content-Type: application/json" \
-d '{
    "description": "An application is failing to get new database connections and is logging ''Timeout waiting for connection from pool'' errors.",
    "namespace": "default",
    "resourceName": "wwwm-mysql-dummy",
    "triggeredBy": "Simulation-CURL-3.5"
}'

### llama3-serving log
INFO:     Started server process [1]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8081 (Press CTRL+C to quit)