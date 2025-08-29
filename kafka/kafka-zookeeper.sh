# containerd 사용 시
sudo crictl images pull docker.io/bitnami/kafka:3.7.0-debian-12-r6

# 메모리 절약과 ZK 모드를 사용하기 위해 28.3.0으로 다운그레이드하여 설치\
# 3.7.1-debian-12-r9 이미지로 태그 명시
helm install kafka bitnami/kafka \
  --version 28.3.0 \
  -f kafka-values.yaml \
  --set image.tag=3.7.1-debian-12-r9 \
  -n kafka

k logs -f -n kafka kafka-broker-0

#############################
# kafka Helm 차트 삭제
helm uninstall kafka -n kafka

# PVC 삭제
k delete pvc data-kafka-broker-0
k delete pvc data-kafka-zookeeper-0