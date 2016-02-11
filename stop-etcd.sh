#!/bin/bash

# Stop etcd
docker kill etcd

# Remove etcd
docker rm etcd
