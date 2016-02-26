#!/bin/bash

# Generate certs for apiserver
openssl genrsa -out apiserver-key.pem 4096
openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kubernetes-apiserver" -config apiserver-openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile apiserver-openssl.cnf
rm -f apiserver.csr
chmod 0400 apiserver-key.pem
chmod 0444 apiserver.pem

# Generate certs for scheduler
openssl genrsa -out scheduler-key.pem 4096
openssl req -new -key scheduler-key.pem -out scheduler.csr -subj "/CN=kubernetes-scheduler" -config scheduler-openssl.cnf
openssl x509 -req -in scheduler.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out scheduler.pem -days 365 -extensions v3_req -extfile scheduler-openssl.cnf
rm -f scheduler.csr
chmod 0400 scheduler-key.pem
chmod 0444 scheduler.pem

# Generate certs for controller manager
openssl genrsa -out controller-mgr-key.pem 4096
openssl req -new -key controller-mgr-key.pem -out controller-mgr.csr -subj "/CN=kubernetes-controller-mgr" -config controller-mgr-openssl.cnf
openssl x509 -req -in controller-mgr.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out controller-mgr.pem -days 365 -extensions v3_req -extfile controller-mgr-openssl.cnf
rm -f controller-mgr.csr
chmod 0400 controller-mgr-key.pem
chmod 0444 controller-mgr.pem
