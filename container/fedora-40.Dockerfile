FROM docker.io/fedora:40

MAINTAINER Pengfei Ding "pding@lbl.ggov"

RUN yum clean all \
 && yum -y update \
 && yum -y install findutils wget which git vim nmap tcpdump procps-ng gdb curl \
 && yum clean all

CMD ["/bin/bash"]