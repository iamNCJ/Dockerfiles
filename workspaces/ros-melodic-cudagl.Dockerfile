FROM nvidia/cudagl:11.1-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

# config
ENV USER=rosuser
ENV PASSWD=rosuser
# UID and GID should match that of the host user
ENV UID=1000
ENV GID=1000
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# preflight
RUN sed -i 's/http:\/\/.*\ubuntu/http:\/\/mirrors.bfsu.edu.cn\/ubuntu/g' /etc/apt/sources.list && \ 
    apt-get update && apt-get install -y \
    mesa-utils wget sudo apt-utils curl vim virtualenv locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# install ros
RUN sh -c 'echo "deb http://mirrors.bfsu.edu.cn/ros/ubuntu/ bionic main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    rm -rf /var/lib/apt/lists/* && apt-get update && apt-get install -y \ 
    ros-melodic-desktop-full python-rosdep python-rosinstall python-rosinstall-generator python-wstool python-pip build-essential

# postinatall: add new user & clean up
RUN useradd --create-home -m $USER && \
    echo "$USER:$PASSWD" | chpasswd && \
    usermod --shell /bin/bash $USER && \
    usermod -aG sudo $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod --uid $UID $USER && \
    groupmod --gid $GID $USER && \
    rosdep init 

# setup ros
USER $USER
RUN rosdep update && \
    sh -c 'echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc'

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
