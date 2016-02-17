#!/bin/bash

. env.sh

# Start mesos master
mkdir -p /var/log/mesos
mesos-master --advertise_ip=$MESOS_IP --ip=$MESOS_IP --no-hostname_lookup --work_dir=/var/lib/mesos 1>/var/log/mesos/master.log 2>&1 &
