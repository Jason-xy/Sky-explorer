FROM ubuntu:20.04

RUN sed -i "s@http://.*ports.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list

RUN rm /bin/sh && \
    ln -s /bin/bash /bin/sh

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get install -y curl && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    cmake \
    git \
    unzip \
    libavcodec-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    libavformat-dev \
    libavutil-dev \
    libeigen3-dev \
    libglew-dev \
    libgtk2.0-dev \
    libgtk-3-dev \
    libjpeg-dev \
    libpng-dev \
    libpostproc-dev \
    libswscale-dev \
    libtbb-dev \
    libtiff5-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    qt5-default \
    zlib1g-dev \
    pkg-config \
    ros-foxy-desktop \
    python3-argcomplete \
    ros-dev-tools \
    python-dev \
    python-numpy \
    python-py \
    python-pytest \
    python3-pip \
    python3-dev \
    python3-numpy \
    python3-py \
    python3-pytest \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev && \
    apt-get clean

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install \
        rosbags \
        wget

# opencv-4.5.4
ENV OPENCV_VERSION="4.5.4"
ENV OPENCV_SOURCE_DIR="/root/3rdparty"
ENV INSTALL_DIR="/usr/local"
RUN mkdir -p $OPENCV_SOURCE_DIR && cd $OPENCV_SOURCE_DIR && \
    wget -O opencv.zip https://github.com/Itseez/opencv/archive/${OPENCV_VERSION}.zip && \
    wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
    unzip opencv.zip && \
    unzip opencv_contrib.zip && \
    cd $OPENCV_SOURCE_DIR/opencv-${OPENCV_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
        -D ENABLE_FAST_MATH=ON \
        -D WITH_LIBV4L=ON \
        -D WITH_V4L=ON \
        -D WITH_GSTREAMER=ON \
        -D WITH_GSTREAMER_0_10=OFF \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_opencv_python2=ON \
        -D BUILD_opencv_python3=ON \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
        ../ && \
        make -j$(nproc) && \
        make install && \
        ldconfig && \
        rm -rf $OPENCV_SOURCE_DIR/*

# ceres-solver-2.1.0 with cuda
RUN cd $OPENCV_SOURCE_DIR && \
    wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz && \
    tar zxf ceres-solver-2.1.0.tar.gz && \
    mkdir ceres-bin && \
    cd ceres-bin && \
    cmake ../ceres-solver-2.1.0 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $OPENCV_SOURCE_DIR/*

# Librealsense2
RUN apt-get update && \
    apt-get install -y\
    libssl-dev \
    libusb-1.0-0-dev \
    pkg-config \
    build-essential \
    cmake \
    cmake-curses-gui \
    libgtk-3-dev \
    libglfw3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    qtcreator

RUN cd $OPENCV_SOURCE_DIR && \
    git clone -b v2.53.1 https://github.com/IntelRealSense/librealsense.git && \
    cd librealsense && \
    ./scripts/setup_udev_rules.sh && \
    mkdir build && \
    cd build && \
    cmake ../ -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_EXAMPLES=true \
        -DFORCE_RSUSB_BACKEND=ON \
        -DBUILD_WITH_TM2=false \
        -DIMPORT_DEPTH_CAM_FW=false && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf $OPENCV_SOURCE_DIR/*

# Other packages
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y \
    ros-noetic-desktop-full \
    ros-foxy-diagnostic-updater && \
    apt-get clean