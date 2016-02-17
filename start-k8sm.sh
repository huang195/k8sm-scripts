#!/bin/bash

. env.sh

# Create manifests directories
mkdir -p /etc/kubernetes/manifests
mkdir -p /srv/kubernetes/manifests

# Create apiserver template file
cat <<EOF > /etc/kubernetes/manifests/apiserver.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kube-apiserver
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: kube-apiserver
    image: haih/k8sm:latest
    command:
    - /opt/kubernetes/km
    - apiserver
    - --bind-address=0.0.0.0
    - --insecure-bind-address=0.0.0.0
    - --etcd-servers=http://${ETCD_IP}:${ETCD_PORT}
    - --allow-privileged=true
    - --service-cluster-ip-range=10.10.10.0/24
    - --secure-port=${K8S_SECURE_PORT}
    - --cloud-provider=mesos
    - --cloud-config=/etc/kubernetes/mesos-cloud.conf
    - --advertise-address=${NODE_IP}
    ports:
    - containerPort: ${K8S_SECURE_PORT}
      hostPort: ${K8S_SECURE_PORT}
      name: https
    - containerPort: ${K8S_INSECURE_PORT}
      hostPort: ${K8S_INSECURE_PORT}
      name: local
    volumeMounts:
    - mountPath: /etc/kubernetes
      name: kubernetes-config
      readOnly: true
  volumes:
  - hostPath:
      path: /etc/kubernetes
    name: kubernetes-config
EOF

# Create podmaster template file
cat <<EOF > /etc/kubernetes/manifests/podmaster.yaml
piVersion: v1
kind: Pod
metadata:
  name: kube-podmaster
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: scheduler-elector
    image: gcr.io/google_containers/podmaster:1.1
    command:
    - /podmaster
    - --etcd-servers=http://${ETCD_IP}:${ETCD_PORT}
    - --key=scheduler
    - --whoami=${NODE_IP}
    - --source-file=/src/manifests/scheduler.yaml
    - --dest-file=/dst/manifests/scheduler.yaml
    volumeMounts:
    - mountPath: /src/manifests
      name: manifest-src
      readOnly: true
    - mountPath: /dst/manifests
      name: manifest-dst
  - name: controller-manager-elector
    image: gcr.io/google_containers/podmaster:1.1
    command:
    - /podmaster
    - --etcd-servers=http://${ETCD_IP}:${ETCD_PORT}
    - --key=controller
    - --whoami=${NODE_IP}
    - --source-file=/src/manifests/controller-mgr.yaml
    - --dest-file=/dst/manifests/controller-mgr.yaml
    terminationMessagePath: /dev/termination-log
    volumeMounts:
    - mountPath: /src/manifests
      name: manifest-src
      readOnly: true
    - mountPath: /dst/manifests
      name: manifest-dst
  volumes:
  - hostPath:
      path: /srv/kubernetes/manifests
    name: manifest-src
  - hostPath:
      path: /etc/kubernetes/manifests
    name: manifest-dst
EOF

# Create scheduler template file
cat <<EOF > /srv/kubernetes/manifests/scheduler.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kube-scheduler
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: kube-scheduler
    image: haih/k8sm:latest
    command:
    - /opt/kubernetes/km
    - scheduler
    - --address=${NODE_IP}
    - --mesos-master=${MESOS_IP}:${MESOS_PORT}
    - --etcd-servers=http://${ETCD_IP}:${ETCD_PORT}
    - --api-servers=${K8S_IP}:${K8S_INSECURE_PORT}
EOF

# Create controller manager template file
cat <<EOF > /srv/kubernetes/manifests/controller-mgr.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kube-controller-manager
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: kube-controller-manager
    image: haih/k8sm:latest
    command:
    - /opt/kubernetes/km
    - controller-manager
    - --master=http://127.0.0.1:8080
    - --cloud-provider=mesos
    - --cloud-config=/etc/kubernetes/mesos-cloud.conf
    volumeMounts:
    - mountPath: /etc/kubernetes
      name: kubernetes-config
      readOnly: true
  volumes:
  - hostPath:
      path: /etc/kubernetes
    name: kubernetes-config
EOF 

cat <<EOF >/etc/kubernetes/mesos-cloud.conf
[mesos-cloud]
        mesos-master        = ${MESOS_IP}:${MESOS_PORT}
EOF

mkdir -p /var/log/kubernetes
kubelet \
  --api_servers=http://127.0.0.1:${K8S_INSECURE_PORT} \
  --register-node=false \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests \
  --v=0 \
  1>/var/log/kubernetes/kubelet.log 2>&1 &
