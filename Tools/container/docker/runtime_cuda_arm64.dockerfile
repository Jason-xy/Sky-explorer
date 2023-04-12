FROM nvcr.io/nvidia/l4t-jetpack:r35.1.0

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

# opencv-4.5.4-cuda11.4
ENV ARCH_BIN="7.2"
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
        -D WITH_CUDA=ON \
        -D CUDA_ARCH_BIN=${ARCH_BIN} \
        -D CUDA_ARCH_PTX="" \
        -D ENABLE_FAST_MATH=ON \
        -D CUDA_FAST_MATH=ON \
        -D WITH_CUBLAS=ON \
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
    cmake -DCUDA=ON \
        ../ceres-solver-2.1.0 && \
    make -j$(nproc) && \
    make install && \
    rm -rf $OPENCV_SOURCE_DIR/*

# Librealsense2
RUN git clone https://github.com/Jason-xy/buildLibrealsense2Xavier.git && \
    cd buildLibrealsense2Xavier && \
    ./installLibrealsense.sh && \
    apt-get clean && \
    rm -rf /buildLibrealsense2Xavier && \
    rm -rf /root/*