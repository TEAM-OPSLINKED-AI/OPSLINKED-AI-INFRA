[root@master opslinked-ai]# k get pod
NAME                                             READY   STATUS    RESTARTS        AGE
go-metric-producer-deployment-5bb864bb48-f9n69   1/1     Running   0               24s
wwwm-mysql-6b74788df8-vcszk                      2/2     Running   0               64d
wwwm-spring-be-v2-56d77c4bbf-t89wp               1/1     Running   0               2d15h

[root@master opslinked-ai]# k logs -f go-metric-producer-deployment-5bb864bb48-jr5sw
2025/09/03 04:28:26 경고: .env 파일을 찾을 수 없습니다. 운영체제의 환경 변수를 사용합니다.
2025/09/03 04:28:26 설정 로드가 완료되었습니다.
2025/09/03 04:28:26 메트릭 수집 및 전달 스케줄러를 시작합니다. 1분마다 실행됩니다.
2025/09/03 04:28:26 작업을 시작합니다...
2025/09/03 04:28:26 INFO: 'Spring BE Actuator'의 메트릭 수집을 시작합니다... (URL: http://wwwm-spring-be-service.default.svc.cluster.local:8080/actuator/prometheus)
2025/09/03 04:28:26 INFO: 'Node Exporter'의 메트릭 수집을 시작합니다... (URL: http://kube-prometheus-stack-prometheus-node-exporter.monitoring.svc.cluster.local:9100/metrics)
2025/09/03 04:28:26 INFO: 'MySQL Exporter'의 메트릭 수집을 시작합니다... (URL: http://wwwm-mysql-exporter-svc.default.svc.cluster.local:9104/metrics)
2025/09/03 04:28:26 INFO: 'Node Exporter'의 메트릭 1125개를 'node-exporter-metrics' 토픽으로 성공적으로 전송 요청했습니다.
2025/09/03 04:28:26 INFO: 'Spring BE Actuator'의 메트릭 329개를 'spring-actuator-metrics' 토픽으로 성공적으로 전송 요청했습니다.
2025/09/03 04:28:26 INFO: 'MySQL Exporter'의 메트릭 1064개를 'mysql-exporter-metrics' 토픽으로 성공적으로 전송 요청했습니다.
2025/09/03 04:28:26 모든 작업이 완료되었습니다.
2025/09/03 04:29:26 작업을 시작합니다...
2025/09/03 04:29:26 INFO: 'Node Exporter'의 메트릭 수집을 시작합니다... (URL: http://kube-prometheus-stack-prometheus-node-exporter.monitoring.svc.cluster.local:9100/metrics)
2025/09/03 04:29:26 INFO: 'Spring BE Actuator'의 메트릭 수집을 시작합니다... (URL: http://wwwm-spring-be-service.default.svc.cluster.local:8080/actuator/prometheus)
2025/09/03 04:29:26 INFO: 'MySQL Exporter'의 메트릭 수집을 시작합니다... (URL: http://wwwm-mysql-exporter-svc.default.svc.cluster.local:9104/metrics)
2025/09/03 04:29:26 INFO: 'Spring BE Actuator'의 메트릭 329개를 'spring-actuator-metrics' 토픽으로 성공적으로 전송 요청했습니다.
2025/09/03 04:29:26 INFO: 'Node Exporter'의 메트릭 1125개를 'node-exporter-metrics' 토픽으로 성공적으로 전송 요청했습니다.
2025/09/03 04:29:26 INFO: 'MySQL Exporter'의 메트릭 1064개를 'mysql-exporter-metrics' 토픽으로 성공적으로 전송 요청했습니다.
2025/09/03 04:29:26 모든 작업이 완료되었습니다.

#############################################
$ bin/kafka-console-consumer.sh   --bootstrap-server _:9095    --topic spring-actuator-metrics --from-beginning --partition 0
...
system_cpu_count 1.0
system_cpu_usage 0.0246161858974359
system_load_average_1m 0.31396484375
...

$ bin/kafka-console-consumer.sh   --bootstrap-server _:9095    --topic spring-actuator-metrics --from-beginning --partition 0
...
system_cpu_count 1.0
system_cpu_usage 0.0128239010989011
system_load_average_1m 0.2158203125
...