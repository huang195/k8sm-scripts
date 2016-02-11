FROM ubuntu

MAINTAINER Hai Huang <haih@us.ibm.com>

RUN mkdir -p /opt/kubernetes

COPY kubernetes/_output/dockerized/bin/linux/amd64/ /opt/kubernetes

ENTRYPOINT ["/opt/kubernetes/km"]
