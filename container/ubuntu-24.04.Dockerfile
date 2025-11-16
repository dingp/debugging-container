From ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive
RUN \
    apt-get update        &&   \
    apt-get install --yes      \
        wget                   \
        findutils              \
        wget                   \
        git                    \
        vim                    \
        nmap                   \
        tcpdump                \
        procps                 \
        gdb                    \
        gcc                    \
        make                   \
        curl                   \
        zlib1g-dev             \
        nfs-common             \
        iproute2           &&   \
    apt-get clean all

ADD scripts/flush100.sh /opt/flush100.sh
ADD scripts/blkio.py /opt/blkio.py


CMD ["/bin/bash"]
