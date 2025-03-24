FROM docker.io/fedora:41

MAINTAINER Pengfei Ding "pding@lbl.ggov"

RUN yum clean all \
 && yum -y update \
 && yum -y install findutils wget which git vim nmap tcpdump procps-ng gdb curl iproute openssl-devel zlib-devel gcc perl \
 && yum clean all

CMD ["/bin/bash"]
