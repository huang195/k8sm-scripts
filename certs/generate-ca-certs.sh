#!/bin/bash
openssl genrsa -out ca-key.pem 4096
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kubernetes-ca"
chmod 0400 ca-key.pem
chmod 0444 ca.pem
