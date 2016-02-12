#!/bin/bash

# Set mesos master ip address here
MESOS_MASTER_IPADDR=10.143.100.209
MESOS_MASTER_PORT=5050

# Assume eth0 is the interface mesos slave should be listen on
IF=eth0
IPADDR=`ip addr show $IF | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`

# Start mesos slave
mkdir -p /var/log/mesos
mesos-slave --ip=$IPADDR --advertise_ip=$IPADDR --no-hostname_lookup --master=${MESOS_MASTER_IPADDR}:${MESOS_MASTER_PORT} 1>/var/log/mesos/slave.log 2>&1 &
