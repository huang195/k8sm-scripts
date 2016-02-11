#!/bin/bash
killall -9 km
killall -9 mesos-slave
service docker restart
sleep 1
docker rm `docker ps -aq`
service docker restart
rm -rf /tmp/mesos
