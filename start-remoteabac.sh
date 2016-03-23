#!/bin/bash

. env.sh

#remoteabac --address=${RABAC_IP}:${RABAC_PORT} --tls-cert-file=/var/run/kubernetes/apiserver.pem --tls-private-key-file=/var/run/kubernetes/apiserver-key.pem --authorization-policy-file=/etc/kubernetes/k8sm-auth-policy 1> abac.log 2>&1 &

docker exec etcd /etcdctl set /abac-policy '
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "kubernetes-scheduler", "nonResourcePath": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "kubernetes-scheduler", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "kubernetes-controller-mgr", "nonResourcePath": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "kubernetes-controller-mgr", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "kubelet", "nonResourcePath": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "kubelet", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "proxy", "nonResourcePath": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "proxy", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "admin", "nonResourcePath": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "admin", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "*", "nonResourcePath": "/api", "readonly": true}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "*", "nonResourcePath": "/api/*/", "readonly": true}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "*", "nonResourcePath": "/apis/", "readonly": true}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "*", "nonResourcePath": "/apis/*", "readonly": true}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "*", "nonResourcePath": "/apis/*/*", "readonly": true}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "*", "nonResourcePath": "/apis/*/*", "readonly": true}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "*", "nonResourcePath": "version", "readonly": true}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "alice", "namespace": "alice", "resource": "*", "apiGroup": "*"}}
'

docker run -p ${RABAC_PORT}:${RABAC_PORT} \
        -v /var/run/kubernetes/:/var/run/kubernetes \
        --name remoteabac \
        -d \
        haih/remoteabac \
        --address=:8888 \
        --tls-cert-file=/var/run/kubernetes/apiserver.pem \
        --tls-private-key-file=/var/run/kubernetes/apiserver-key.pem \
        --authorization-policy-file=etcd@http://${ETCD_IP}:${ETCD_PORT}/abac-policy
