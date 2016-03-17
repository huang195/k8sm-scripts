#!/bin/bash

. env.sh

#remoteabac --address=${RABAC_IP}:${RABAC_PORT} --tls-cert-file=/var/run/kubernetes/apiserver.pem --tls-private-key-file=/var/run/kubernetes/apiserver-key.pem --authorization-policy-file=/etc/kubernetes/k8sm-auth-policy 1> abac.log 2>&1 &

docker run -p ${RABAC_PORT}:{$RABAC_PORT} \
	-v /var/run/kubernetes/:/var/run/kubernetes \
	haih/remoteabac \
	-name remoteabac \
	--address=:8888 \
	--tls-cert-file=/var/run/kubernetes/apiserver.pem \
	--tls-private-key-file=/var/run/kubernetes/apiserver-key.pem \
	--authorization-policy-file=etcd@http://10.143.100.209:4001/abac-policy

