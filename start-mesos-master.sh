#!/bin/bash

# Assume eth0 is the interface mesos master should be listen on
IF=eth0
IPADDR=`ip addr show $IF | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`

# Start mesos master
mkdir -p /var/log/mesos
mesos-master --advertise_ip=$IPADDR --ip=$IPADDR --nohostname_lookup --work_dir=/var/lib/mesos 1>/var/log/mesos/master.log 2>&1 &
