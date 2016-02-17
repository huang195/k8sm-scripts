#!/bin/bash

# Finally kill the kubelet itself
killall -9 kubelet

# Delete the kubernetes master components
rm -f /etc/kubernetes/manifests/*
rm -f /srv/kubernetes/manifests/*

# Remove containers started by k8s
docker stop `docker ps | grep k8s_ | awk '{print $1}'`
sleep 1
docker rm `docker ps -a | grep k8s_ | awk '{print $1}'`
