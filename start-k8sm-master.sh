#!/bin/bash

# Kubernetes master port

mkdir -p /etc/kubernetes/manifests
mkdir -p /srv/kubernetes/manifests

kubelet \
  --api_servers=http://127.0.0.1:8080 \
  --register-node=false \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests
