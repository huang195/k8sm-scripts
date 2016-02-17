#!/bin/bash

. env.sh

# Start mesos slave
mkdir -p /var/log/mesos
mesos-slave --ip=$NODE_IP --no-hostname_lookup --master=${MESOS_IP}:${MESOS_PORT} 1>/var/log/mesos/slave.log 2>&1 &
