#!/bin/bash

function qdocker_func() {
  docker run \
	-v $DOCKER_QNAP_CLIENT_CREDENTIALS/ca.pem:/certs/ca.pem:ro \
	-v $DOCKER_QNAP_CLIENT_CREDENTIALS/cert.pem:/certs/cert.pem:ro \
	-v $DOCKER_QNAP_CLIENT_CREDENTIALS/key.pem:/certs/key.pem:ro \
        -v `pwd`:/workdir \
	-u $UID:$UID \
        --workdir /workdir \
	-e DOCKER_HOST=$DOCKER_QNAP_HOST \
	-e DOCKER_TLS_VERIFY=1 \
	-it \
	--rm \
	docker-client:1.12.2 --tlscacert=/certs/ca.pem --tlscert=/certs/cert.pem --tlskey=/certs/key.pem --tlsverify=true $@
}

qdocker_func "$@"
