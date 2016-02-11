#!/bin/bash

# Make sure i) can sudo as root and ii) Docker is running

K8SM_IMAGE_NAME=haih/k8sm

git clone http://github.com/kubernetes/kubernetes
cd kubernetes
git checkout release-1.1
sudo KUBERNETES_CONTRIB=mesos build/run.sh hack/build-go.sh
cd ..
sudo docker build -t $K8SM_IMAGE_NAME --no-cache .

# Optionally one can push the image
#docker push $K8SM_IMAGE_NAME
