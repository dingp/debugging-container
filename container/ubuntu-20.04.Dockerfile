From ubuntu:20.04

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
        curl                   \
        iproute2           &&   \
    apt-get clean all


CMD ["/bin/bash"]
