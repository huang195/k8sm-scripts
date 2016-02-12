#!/bin/bash

MESOS_VERSION=0.27.0

# Download and extract source code
wget http://www.apache.org/dist/mesos/${MESOS_VERSION}/mesos-${MESOS_VERSION}.tar.gz
tar -zxf mesos-${MESOS_VERSION}.tar.gz
mv mesos-${MESOS_VERSION} mesos

# Install dependencies
apt-get update
apt-get install -y tar wget git
apt-get install -y openjdk-7-jdk
apt-get install -y autoconf libtool
apt-get -y install build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev

# Build
cd mesos
mkdir build
cd build
../configure
make -j4 -V=0
make install
ldconfig
