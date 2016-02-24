#!/bin/bash

. env.sh

# Start etcd
docker run -d --hostname $(uname -n) --name etcd \
  -p ${ETCD_PORT}:${ETCD_PORT} \
  quay.io/coreos/etcd:v2.0.12 \
  --listen-client-urls http://0.0.0.0:${ETCD_PORT} \
  --advertise-client-urls http://${ETCD_IP}:${ETCD_PORT}
