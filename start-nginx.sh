#!/bin/bash

. env.sh

docker run -p $NGINX_APISERVER_PORT:$NGINX_APISERVER_PORT -p $NGINX_SCHEDULER_PORT:$NGINX_SCHEDULER_PORT --name nginx -v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx:latest

