FROM nvidia/cuda:10.2-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    git \
    cmake \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-regex-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libcgal-qt5-dev

# Change dir, put all sources under /src
RUN mkdir /src
WORKDIR /src

# Install Ceres Solver
RUN apt-get install -y libatlas-base-dev libsuitesparse-dev && \
    git clone https://ceres-solver.googlesource.com/ceres-solver && \
    cd ceres-solver && \
    git checkout 2.0.0 && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
    make -j && \
    make install

# Install Colmap
RUN git clone https://github.com/colmap/colmap.git && \
    cd colmap && \
    git checkout 3.6 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install

RUN mkdir /workspace
WORKDIR /workspace

ENTRYPOINT [ "/bin/bash" ]
