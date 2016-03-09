#!/bin/bash

# generate certs for kubelet
openssl genrsa -out kubelet-key.pem 4096
openssl req -subj '/CN=kubelet' -new -key kubelet-key.pem -out kubelet.csr
echo extendedKeyUsage = clientAuth > kubelet-openssl.cnf
openssl x509 -req -days 1500 -sha256 -in kubelet.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out kubelet.pem -extfile kubelet-openssl.cnf
rm -f kubelet.csr

# generate certs for proxy
openssl genrsa -out proxy-key.pem 4096
openssl req -subj '/CN=proxy' -new -key proxy-key.pem -out proxy.csr
echo extendedKeyUsage = clientAuth > proxy-openssl.cnf
openssl x509 -req -days 1500 -sha256 -in proxy.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out proxy.pem -extfile proxy-openssl.cnf
rm -f proxy.csr
