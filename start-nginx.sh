#!/bin/bash

. env.sh

docker run -p $K8S_NGINX_INSECURE_PORT:$K8S_NGINX_INSECURE_PORT -p $K8S_NGINX_SCHEDULER_PORT:$K8S_NGINX_SCHEDULER_PORT --name nginx -v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx:latest

