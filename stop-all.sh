service kubelet stop
docker kill `docker ps -q`
docker rm `docker ps -aq`
service docker stop
service docker start
killall -9 ucarp
ip addr del 10.140.146.3/26 dev eth0
rm -rf /var/etcd/data/*

