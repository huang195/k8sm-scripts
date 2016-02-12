#!/bin/bash

# Set mesos master ip address here
MESOS_MASTER_IPADDR=10.143.100.209
MESOS_MASTER_PORT=5050

# Start mesos slave
mkdir -p /var/log/mesos
$HOME/mesos/build/bin/mesos-slave.sh --master=${MESOS_MASTER_IPADDR}:${MESOS_MASTER_PORT} 1>/var/log/mesos/slave.log 2>&1 &
