#!/bin/bash
openssl genrsa -out kubelet-key.pem 4096
openssl req -subj '/CN=kubelet' -new -key kubelet-key.pem -out kubelet.csr
echo extendedKeyUsage = clientAuth > kubelet-openssl.cnf
openssl x509 -req -days 1500 -sha256 -in kubelet.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out kubelet.pem -extfile kubelet-openssl.cnf
rm -f kubelet.csr
