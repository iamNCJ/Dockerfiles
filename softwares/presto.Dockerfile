FROM ubuntu:18.04

RUN sed -i 's/archive.ubuntu.com/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install git build-essential automake checkinstall gfortran python3 python3-pip libfftw3-bin libfftw3-dev pgplot5 libglib2.0-dev libcfitsio3 libcfitsio-dev -y && \
    cd /root && git clone http://git.code.sf.net/p/tempo/tempo --depth 1 && \
    cd tempo && autoreconf --install && make -j$(nproc) && make install && \
    cd /root && git clone https://github.com/scottransom/presto && \
    export PRESTO=/root/presto && cd $PRESTO/src && make makewisdom && make prep && make -j$(nproc) && \
    pip3 install -i https://mirrors.bfsu.edu.cn/pypi/web/simple numpy scipy

ENTRYPOINT [ "gns3server" ]