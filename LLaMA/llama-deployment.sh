# pwd
/home/judemin/opslinked-a

# vim Dockerfile

# docker build -t llama3-cpu-server .
[+] Building 29.0s (5/7)                                                docker:default
 => [internal] load build definition from Dockerfile                              0.0s
 => => transferring dockerfile: 1.43kB                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.10-slim               2.8s
 => [internal] load .dockerignore                                                 0.0s
 => => transferring context: 2B                                                   0.0s
 => [1/4] FROM docker.io/library/python:3.10-slim@sha256:e0c4fae70d550834a40f6c3  7.1s
 => => resolve docker.io/library/python:3.10-slim@sha256:e0c4fae70d550834a40f6c3  0.0s
 => => sha256:e0c4fae70d550834a40f6c3e0326e02cfe239c2351d922e1 10.37kB / 10.37kB  0.0s
 => => sha256:9e6a62a66f88f5b5be9434fe50af75bcafb8732bafe766a60f 1.75kB / 1.75kB  0.0s
 => => sha256:4fb709907e2aafb8dc8d3ab30868fa5bda925514344c204d0c 5.38kB / 5.38kB  0.0s
 => => sha256:38513bd7256313495cdd83b3b0915a633cfa475dc2a07072 29.78MB / 29.78MB  4.7s
 => => sha256:dcc665d66e712e17c182277008fb8820d04d1daf02ddd72dc0 1.29MB / 1.29MB  1.8s
 => => sha256:296e07bd32e322a19461db84fbcad96046830fff3ce826a2 13.82MB / 13.82MB  2.1s
 => => sha256:a9a29352df11cfa64d30061c8bd8ba24701fc8d9100bd42b62c0d0 250B / 250B  2.3s
 => => extracting sha256:38513bd7256313495cdd83b3b0915a633cfa475dc2a07072ab2c8d1  1.1s
 => => extracting sha256:dcc665d66e712e17c182277008fb8820d04d1daf02ddd72dc03cad5  0.1s
 => => extracting sha256:296e07bd32e322a19461db84fbcad96046830fff3ce826a2a25c568  0.9s
 => => extracting sha256:a9a29352df11cfa64d30061c8bd8ba24701fc8d9100bd42b62c0d0e  0.0s
 => [2/4] WORKDIR /app                                                            0.4s
 => [3/4] RUN pip install --no-cache-dir llama-cpp-python[server] huggingface-h  18.7s
 => => # :00
 => => # Collecting numpy>=1.20.0
 => => #   Downloading numpy-2.2.6-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86
 => => # _64.whl (16.8 MB)
 => => #      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 16.8/16.8 MB 11.4 MB/s eta 0:00
 => => # :00

# docker run -d -p 8080:8000 --name llama3-service llama3-cpu-server

# docker logs -f llama3-service