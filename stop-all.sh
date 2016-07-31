service kubelet stop
docker kill `docker ps -q`
docker rm `docker ps -aq`
service docker stop
rm -rf /openstack/docker/*
service docker start
killall -9 ucarp
rm -rf /var/etcd/data/*
rm -rf /etc/kubernetes
rm -rf /srv/kubernetes

ip addr del 10.140.146.0/26 dev eth0
