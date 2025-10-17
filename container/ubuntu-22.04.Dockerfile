From ubuntu:22.04

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
        fio                    \
        zlib1g-dev             \
        iproute2           &&   \
    apt-get clean all


CMD ["/bin/bash"]
