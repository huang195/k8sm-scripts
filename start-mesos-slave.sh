#!/bin/bash

# Set mesos master ip address here
MESOS_MASTER_IPADDR=10.143.100.209

# Start mesos slave
mkdir -p /var/log/mesos
mesos-slave --master=${MESOS_MASTER_IPADDR} 1>/var/log/mesos/slave.log 2>&1 &
