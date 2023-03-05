FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility

RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo git clang-10 libc++-10-dev libc++abi-10-dev cmake ninja-build libpng-dev libjpeg-dev libpython3-dev python3-distutils python3-pytest python3-pytest-xdist python3-numpy python3-setuptools python3-pip

RUN useradd -rm -d /home/mitsuba -s /bin/bash -g root -G sudo -u 1000 mitsuba && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER mitsuba
WORKDIR /home/mitsuba

ARG MITSUBA3_COMMIT=50e1fc41d3ca16e5b1b4899ec594b398bde297c2
RUN git clone --recursive https://github.com/mitsuba-renderer/mitsuba3 && cd mitsuba3 && git checkout ${MITSUBA3_COMMIT}
ENV CC=clang-10
ENV CXX=clang++-10
RUN mkdir /home/mitsuba/mitsuba3/build
COPY mitsuba3.conf /home/mitsuba/mitsuba3/build/mitsuba.conf
RUN cd ~/mitsuba3/build && cmake -GNinja .. && ninja
ENTRYPOINT [ "/bin/bash", "-c", "source /home/mitsuba/mitsuba3/build/setpath.sh && \"$@\"", "-s" ]
