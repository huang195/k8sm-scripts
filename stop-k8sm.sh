#!/bin/bash

# Delete the kubernetes master components
rm -f /etc/kubernetes/manifests/*

# Wait 30 seconds for kubelet to clean up
sleep 30

# Finally kill the kubelet itself
killall -9 kubelet

# Remove dead containers
docker rm `docker ps -aq --filter=status=exited`
