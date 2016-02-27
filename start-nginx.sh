#!/bin/bash

. env.sh

docker run \
    -p $NGINX_APISERVER_SPORT:$NGINX_APISERVER_SPORT \
    -p $NGINX_APISERVER_PORT:$NGINX_APISERVER_PORT \
    -p $NGINX_SCHEDULER_PORT:$NGINX_SCHEDULER_PORT \
    -v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v /var/run/kubernetes/:/etc/ssl/:ro \
    --name nginx \
    -d nginx:latest
