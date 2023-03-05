FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility

RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo git clang-9 libc++-9-dev libc++abi-9-dev cmake ninja-build libz-dev libpng-dev libjpeg-dev libxrandr-dev libxinerama-dev libxcursor-dev python3-dev python3-distutils python3-setuptools python3-pip

RUN useradd -rm -d /home/mitsuba -s /bin/bash -g root -G sudo -u 1000 mitsuba && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER mitsuba
WORKDIR /home/mitsuba

RUN git clone --recursive https://github.com/mitsuba-renderer/mitsuba2
COPY mitsuba2.conf /home/mitsuba/mitsuba2/mitsuba.conf
RUN cd ~/mitsuba2 && mkdir build && cd build && cmake -GNinja .. && ninja
ENTRYPOINT [ "/bin/bash", "-c", "source /home/mitsuba/mitsuba2/build/setpath.sh && \"$@\"", "-s" ]
