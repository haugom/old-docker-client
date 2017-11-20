FROM ubuntu:16.04
RUN apt-get update && apt-get install -y \
  curl \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  && curl -fsSL https://apt.dockerproject.org/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-xenial main" \
  && apt-get update \
  && apt-get install -y docker-engine=1.11.2-0~xenial \
  && apt-get -y purge curl software-properties-common  \
&& rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["docker"]
CMD ["--help"]
