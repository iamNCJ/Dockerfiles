FROM nvidia/cuda:11.4.2-devel-ubuntu20.04

RUN useradd -rm -d /home/mitsuba -s /bin/bash -g root -G sudo -u 1000 mitsuba
USER mitsuba
WORKDIR /home/mitsuba

RUN apt-get update && apt-get upgrade && apt-get install -y git clang-9 libc++-9-dev libc++abi-9-dev cmake ninja-build libz-dev libpng-dev libjpeg-dev libxrandr-dev libxinerama-dev libxcursor-dev python3-dev python3-distutils python3-setuptools

RUN git clone --recursive https://github.com/mitsuba-renderer/mitsuba2
COPY mitsuba.conf ~/mitsuba2/
RUN cd ~/mitsuba2 && mkdir build && cd build && cmake -GNinja .. && ninja
