#!/bin/bash

# Assume eth0 is the public IP interface
IF=eth0
NODE_IP=`ip addr show $IF | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`

# Points to nginx that proxies MESOS masters
MESOS_IP=10.143.100.209
MESOS_PORT=5050

# Points to nginx that proxies ETCD nodes
ETCD_IP=10.143.100.209
ETCD_PORT=4001

# Points to nginx that proxies KUBERNETES masters
K8S_IP=$NODE_IP
K8S_SECURE_PORT=443
K8S_INSECURE_PORT=8080

# Nginx
NGINX_IP=10.143.100.209
NGINX_APISERVER_PORT=80
NGINX_SCHEDULER_PORT=81
