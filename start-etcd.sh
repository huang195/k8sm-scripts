#!/bin/bash

# Need to set etcd advsertised ip address
ETCD_IPADDR=10.143.100.209

# Start etcd
docker run -d --hostname $(uname -n) --name etcd \
  -p 4001:4001 -p 7001:7001 quay.io/coreos/etcd:v2.0.12 \
  --listen-client-urls http://0.0.0.0:4001 \
  --advertise-client-urls http://${ETCD_IPADDR}:4001
