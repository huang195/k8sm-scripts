#!/bin/bash

. env.sh

# Create manifests directories
mkdir -p /etc/kubernetes/manifests
mkdir -p /srv/kubernetes/manifests

# Create kubernetes logs directory
mkdir -p /var/log/kubernetes

# Create kubernetes certs directory
mkdir -p /var/run/kubernetes/

# Place kubeconfig files
cp kubeconfigs/* /etc/kubernetes/

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
    imagePullPolicy: IfNotPresent
    command:
    - /opt/kubernetes/km
    - apiserver
    - --bind-address=0.0.0.0
    - --insecure-bind-address=0.0.0.0
    - --etcd-servers=http://${ETCD_IP}:${ETCD_PORT}
    - --allow-privileged=true
    - --service-cluster-ip-range=10.10.10.0/24
    - --secure-port=${K8S_SECURE_PORT}
    - --insecure-port=${K8S_INSECURE_PORT}
    - --cloud-provider=mesos
    - --cloud-config=/etc/kubernetes/mesos-cloud.conf
    - --advertise-address=${NODE_IP}
    - --tls-cert-file=/var/run/kubernetes/apiserver.pem
    - --tls-private-key-file=/var/run/kubernetes/apiserver-key.pem
    - --client-ca-file=/var/run/kubernetes/ca.pem
    - --v=0
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
    - mountPath: /var/run/kubernetes
      name: kubernetes-certs
      readOnly: true
  volumes:
  - hostPath:
      path: /etc/kubernetes
    name: kubernetes-config
  - hostPath:
      path: /var/run/kubernetes
    name: kubernetes-certs
EOF

# Create podmaster template file
cat <<EOF > /etc/kubernetes/manifests/podmaster.yaml
apiVersion: v1
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
    imagePullPolicy: IfNotPresent
    command:
    - /opt/kubernetes/km
    - scheduler
    - --address=${NODE_IP}
    - --advertised-address=${NGINX_IP}:${NGINX_SCHEDULER_PORT}
    - --mesos-master=${MESOS_IP}:${MESOS_PORT}
    - --etcd-servers=http://${ETCD_IP}:${ETCD_PORT}
    - --api-servers=https://${NGINX_IP}:${NGINX_APISERVER_SPORT}
    - --kubeconfig=/etc/kubernetes/scheduler-kubeconfig
    - --kubelet-kubeconfig=/etc/kubernetes/kubelet-kubeconfig
    - --proxy-kubeconfig=/etc/kubernetes/proxy-kubeconfig
    - --v=0
    ports:
    - containerPort: ${K8S_SCHEDULER_PORT}
      hostPort: ${K8S_SCHEDULER_PORT}
      name: http
    volumeMounts:
    - mountPath: /etc/kubernetes
      name: kubernetes-config
      readOnly: true
    - mountPath: /var/run/kubernetes
      name: kubernetes-certs
      readOnly: true
  volumes:
  - hostPath:
      path: /etc/kubernetes
    name: kubernetes-config
  - hostPath:
      path: /var/run/kubernetes
    name: kubernetes-certs
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
    imagePullPolicy: IfNotPresent
    command:
    - /opt/kubernetes/km
    - controller-manager
    - --kubeconfig=/etc/kubernetes/controller-manager-kubeconfig
    - --cloud-provider=mesos
    - --cloud-config=/etc/kubernetes/mesos-cloud.conf
    - --v=0
    volumeMounts:
    - mountPath: /etc/kubernetes
      name: kubernetes-config
      readOnly: true
    - mountPath: /var/run/kubernetes
      name: kubernetes-certs
      readOnly: true
  volumes:
  - hostPath:
      path: /etc/kubernetes
    name: kubernetes-config
  - hostPath:
      path: /var/run/kubernetes
    name: kubernetes-certs
EOF

cat <<EOF >/etc/kubernetes/mesos-cloud.conf
[mesos-cloud]
        mesos-master        = ${MESOS_IP}:${MESOS_PORT}
EOF

# Start kubelet so it picks up these template files
kubelet \
  --api_servers=http://127.0.0.1:${K8S_INSECURE_PORT} \
  --register-node=false \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests \
  --v=0 \
  --file-check-frequency=5s \
  1>/var/log/kubernetes/kubelet.log 2>&1 &

# Todo: Need to add a wait for api server to be up before curl command
# Add namespace kube-system
#curl -XPOST -d'{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"kube-system"}}' "http://127.0.0.1:${K8S_INSECURE_PORT}/api/v1/namespaces"
