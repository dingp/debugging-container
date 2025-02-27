FROM docker.io/almalinux:9

MAINTAINER Pengfei Ding "pding@lbl.ggov"

RUN yum clean all \
 && yum -y update \
 && yum -y install --allowerasing findutils wget which git vim nmap tcpdump procps-ng gdb curl iproute \
 && yum clean all

CMD ["/bin/bash"]
