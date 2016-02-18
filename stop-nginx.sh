#!/bin/bash

# Stop etcd
docker kill nginx

# Remove etcd
docker rm nginx
