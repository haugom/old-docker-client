FROM ubuntu:16.04
RUN apt-get update && apt-get install -y \
  curl \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  && apt-get update \
  && apt-get install -y docker-ce=17.09.1~ce-0~ubuntu \
  && apt-get -y purge curl software-properties-common  \
  && apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["docker"]
CMD ["--help"]
