#!/bin/bash

. env.sh

remoteabac --address=${RABAC_IP}:${RABAC_PORT} --tls-cert-file=/var/run/kubernetes/apiserver.pem --tls-private-key-file=/var/run/kubernetes/apiserver-key.pem --authorization-policy-file=/etc/kubernetes/k8sm-auth-policy 1> abac.log 2>&1 &

