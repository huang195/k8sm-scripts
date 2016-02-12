#!/bin/bash

# Kubernetes master port

mkdir -p /etc/kubernetes/manifests
mkdir -p /srv/kubernetes/manifests

cp yaml/apiserver.yaml /etc/kubernetes/manifests/
cp yaml/podmaster.yaml /etc/kubernetes/manifests/
cp yaml/controller-mgr.yaml /srv/kubernetes/manifests/
cp yaml/scheduler.yaml /srv/kubernetes/manifests/

cat <<EOF >mesos-cloud.conf
[mesos-cloud]
        mesos-master        = 10.143.100.209
EOF

kubelet \
  --api_servers=http://127.0.0.1:8080 \
  --register-node=false \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests \
  --v=0 \
  1>kubelet.log 2>&1 &
