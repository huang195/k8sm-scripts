#!/bin/bash

# Kubernetes master port

mkdir -p /etc/kubernetes/manifests
mkdir -p /srv/kubernetes/manifests

cp yaml/scheduler.yaml /etc/kubernetes/manifests/
cp yaml/apiserver.yaml /etc/kubernetes/manifests/
cp yaml/controller-mgr.yaml /etc/kubernetes/manifests/

kubelet \
  --api_servers=http://127.0.0.1:8080 \
  --register-node=false \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests
