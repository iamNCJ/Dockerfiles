FROM ubuntu:18.04

RUN sed -i 's/archive.ubuntu.com/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install git autoconf gfortran python3 python3-pip libfftw3-bin libfftw3-dev pgplot5 libglib2.0-dev libcfitsio-bin libcfitsio-dev -y && \
    python3 -m pip install -i https://mirrors.bfsu.edu.cn/pypi/web/simple numpy scipy

ENTRYPOINT [ "gns3server" ]