#!/bin/bash
openssl genrsa -out admin-key.pem 4096
openssl req -subj '/CN=admin' -new -key admin-key.pem -out admin.csr
echo extendedKeyUsage = clientAuth > admin-openssl.cnf
openssl x509 -req -days 1500 -sha256 -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -extfile admin-openssl.cnf
rm -f admin.csr
