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
