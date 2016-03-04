#!/bin/bash

. env.sh

docker run \
    -p $NGINX_APISERVER_SPORT:$NGINX_APISERVER_SPORT \
    -p $NGINX_APISERVER_PORT:$NGINX_APISERVER_PORT \
    -p $NGINX_SCHEDULER_PORT:$NGINX_SCHEDULER_PORT \
    -v `pwd`/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
    --name haproxy \
    -d haproxy:1.5 haproxy \
    -f /usr/local/etc/haproxy/haproxy.cfg -d
