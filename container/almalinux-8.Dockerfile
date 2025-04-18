FROM docker.io/almalinux:8

MAINTAINER Pengfei Ding "pding@lbl.ggov"

RUN yum clean all \
 && yum -y update \
 && yum -y install --allowerasing findutils wget which git \ 
        vim nmap tcpdump procps-ng gdb curl iproute gcc openssl-devel zlib-devel perl \
 && yum clean all

CMD ["/bin/bash"]
