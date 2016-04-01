#!/bin/bash

mkdir -p data

users=1000

cat > data/baduser << EOF
{
  "apiVersion": "authorization.k8s.io/v1beta1",
  "kind": "SubjectAccessReview",
  "spec": {
    "resourceAttributes": {
      "namespace": "none",
      "verb": "GET",
      "resource": "pods"
    },
    "user": "none"
  }
}
EOF


# Define a timestamp function
timestamp() {
   date +"%s%3N"
}

./stop-remoteabac.sh
./start-remoteabac.sh

for (( i=0; i<$users; i++ ))
do
  tstart=$(timestamp)
  curl -k -d @data/baduser http://localhost:8888/authorize 1>/dev/null 2>&1
  t="$(($(timestamp)-$tstart))"
  echo $t >> data/none

  user=user$i
  ruser --authorization-policy-file=etcd@http://localhost:4001/abac-policy --type=add --user=$user --namespace=$user
done

./stop-remoteabac.sh
