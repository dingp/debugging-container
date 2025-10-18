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

RUN \
    apt-get update        &&   \
    apt-get install --yes      \
        build-essential cmake debhelper devscripts fakeroot git libaio-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libcurl4-openssl-dev libncurses-dev libnuma-dev lintian libssl-dev uuid-dev zlib1g-dev && \
    apt-get clean all

RUN mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/breuner/elbencho.git && \
    cd elbencho && \
    make -j $(nproc) && \
    make deb && \
    apt install ./packaging/elbencho*.deb

RUN \
    apt-get update        &&   \
    apt-get install --yes      \
        nfs-common && \
    apt-get clean all

CMD ["/bin/bash"]
