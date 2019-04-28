Old docker-engine client
---

I acquired a qnap nas device which happends to have build in support to run docker containers. I thought I would have to explore this.

The problem is that the build in version uses docker 1.12.2 which was quite old.

Now my qnap has been upgraded to 17.09.1 which is newer. I have not updated the examples below to reflect the newer version of docker on my qnap.

I came up with the idea of installing docker-engine in a container and run that to talk
to my qnap docker host.

Example:
* download the `certs.zip` bundle from qnap container station and unzip them to `$HOME/.qnap-docker`
* in this example we pretend qnap nas ip address is `192.168.1.10`
* add the `bin/qdocker.sh` script to your path as just `qdocker`

```
docker build -t docker-client:17.09.1 .
export DOCKER_QNAP_HOST=tcp://192.168.1.10:2376
export DOCKER_QNAP_CLIENT_CREDENTIALS=$HOME/.qnap-docker

qdocker ps
qdocker pull jenkins
qdocker images
etc.
```

* I can now keep my normal docker-ce client up to date
* I can use qdocker which runs old version to talk to container station on the qnap
* the qdocker function will run container with version 17.09.1 of docker-ce client
* certificates and key from qnap is mapped inside container
* configure docker (inside container) to talk to your qnap over TLS.
* current working directory is mapped into /workdir such that qdocker load and save works by reading/writing to your current working directory.
* if you run with -v option, remember this is a folder on the nas-qnap and not your local docker instance.

Examples:
```
$ qdocker version
Client:
 Version:      1.11.2
 API version:  1.23
 Go version:   go1.5.4
 Git commit:   b9f10c9
 Built:        Wed Jun  1 22:00:43 2016
 OS/Arch:      linux/amd64

Server:
 Version:      1.11.2
 API version:  1.23
 Go version:   go1.5.4
 Git commit:   781516c
 Built:        Thu Aug  3 16:04:05 2017
 OS/Arch:      linux/amd64

$ docker version
 Client:
  Version:      17.09.0-ce
  API version:  1.32
  Go version:   go1.8.3
  Git commit:   afdb6d4
  Built:        Tue Sep 26 22:42:18 2017
  OS/Arch:      linux/amd64

 Server:
  Version:      17.09.0-ce
  API version:  1.32 (minimum version 1.12)
  Go version:   go1.8.3
  Git commit:   afdb6d4
  Built:        Tue Sep 26 22:40:56 2017
  OS/Arch:      linux/amd64
  Experimental: false

$ qdocker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                        NAMES
dd6fd01f5b16        traefik             "/traefik"          25 hours ago        Up 25 hours         0.0.0.0:82->80/tcp, 0.0.0.0:8082->8080/tcp   sick_newton

$ qdocker pull nginx
latest: Pulling from library/nginx
bc95e04b23c0: Pull complete
a21d9ee25fc3: Pull complete
9bda7d5afd39: Pull complete
Digest: sha256:9fca103a62af6db7f188ac3376c60927db41f88b8d2354bf02d2290a672dc425
Status: Downloaded newer image for nginx:latest

$ cat > index.html <<EOF
<!DOCTYPE HTML>
<html lang="en">
<title>test</title>
<body>
hello qnap
</body>
</html>
EOF

$ scp index.html admin@nas-qnap:/share/CACHEDEV1_DATA/basic_html/

$ qdocker run --name some-nginx -p 8084:80 -v /share/CACHEDEV1_DATA/basic_html:/usr/share/nginx/html:ro -d nginx

$ curl http://nas-qnap:8084
```
