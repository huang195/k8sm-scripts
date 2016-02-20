# k8sm-scripts
Scripts to work with K8sm environment

To start k8sm cluster
=====================

1. Create the cluster, either manually or use ansible scripts
2. Install and configure mesos on all the nodes, either by running install-mesos.sh or ansible scripts
	```
	./install-mesos.sh
	```
3. Create k8sm container image
	```
	cd Dockerfiles
	./build.sh
	```
	This will create haih/k8sm image that can be used to start k8s master components in containers
4. Edit env.sh to suite your specific environment
5. Optionally start mesos
	- On master: `./start-mesos-master.sh`
	- On slaves: `./start-mesos-slave.sh`
6. Optionally start etcd
	```
	./start-etcd.sh
	```
7. Start k8sm
	- On all k8sm masters: `./start-k8sm.sh`

To stop k8sm cluster
====================

1. Stop k8sm
	- On all k8sm masters: `./stop-k8sm.sh`
2. Optionally stop etcd
	```
	./stop-etcd.sh
	```
3. Optionally stop mesos
	- On master: `./stop-mesos-master.sh`
	- On slaves: `./stop-mesos-slave.sh`

Notes
=====

When starting k8sm scheduler, one can pass a list of api servers as one of its parameters, which will be used by
the scheduler to pass it onto the executor/kubelet so it can communicate with the k8sm master. One could potentially
pass the nginx ip/port to the scheduler instead of the list of api servers, but I couldn't get this to work as 
executor/kubelet uses watch for oom events, and watch operation over http is a streaming operation which always 
results in nginx timing out. Unless nginx can be configured to be used as a proxy that supports http streaming,
one should pass a list of api servers to the k8sm scheduler. However, nginx is still useful for kubectl or any
client of k8sm to use to deal with k8s master component failures.
