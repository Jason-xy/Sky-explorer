FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04

ENV ARCH=aarch64 \
    HOSTCC=gcc \
    TARGET=ARMV8

WORKDIR /usr/local

RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    ninja-build \
    git \
    wget \
    zip \
    unzip \
    python3 \
    python3-pip \
    awscli \
    curl \
    sudo \
    vim \
    crossbuild-essential-arm64 \
 && rm -rf /var/lib/apt/lists/*

# python3 modules
RUN python3 -m pip install --upgrade pip && python3 -m pip install \
    setuptools \
    scikit-build

# cmake on Ubuntu 18.04 is too old
RUN python3 -m pip install cmake

# ccache on Ubuntu 18.04 is too old to support Cuda correctly
COPY scripts/ubuntu1804-ccache.sh /ws/
RUN /ws/ubuntu1804-ccache.sh

COPY toolchain/aarch64-linux-gnu-toolchain.cmake /usr
ENV CMAKE_TOOLCHAIN_FILE=/usr/aarch64-linux-gnu-toolchain.cmake

RUN git clone --recursive -b v0.3.12 https://github.com/xianyi/OpenBLAS.git && \
    cd /usr/local/OpenBLAS && \
    make NOFORTRAN=1 CC=aarch64-linux-gnu-gcc && \
    make PREFIX=/usr/aarch64-linux-gnu install && \
    cd /usr/local && \
    rm -rf OpenBLAS

# Install aarch64 cross depedencies based on Jetpack 4.6.2
# Dependencies require cuda-toolkit-10.2 which isn't installed in nvidia docker container
RUN wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-cross-aarch64_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-cudart-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-cufft-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-cupti-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-curand-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-cusolver-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-cusparse-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-driver-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-misc-headers-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-npp-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-nsight-compute-addon-l4t-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-nvgraph-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-nvml-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cuda/cuda-nvrtc-cross-aarch64-10-2_10.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/c/cublas/libcublas-cross-aarch64_10.2.2.89-1_all.deb && \
    wget https://repo.download.nvidia.com/jetson/x86_64/pool/r32.4/n/nsight-compute/nsight-compute-addon-l4t-2019.5.0_2019.5.0.14-1_all.deb && \
    dpkg -i --force-all  *.deb && \
    rm *.deb && \
    apt-get update && \
    apt-get install -y -f && \
    apt-get install -y cuda-cross-aarch64 cuda-cross-aarch64-10-2 && \
    rm -rf /var/lib/apt/lists/*

# nvidia jetpack 4.6.2 installs libcublas.so at /usr/lib/aarch64-linux-gnu
# while previously it used to store it at /usr/local/cuda/targets/aarch64-linux/lib/stubs
RUN ln -s /usr/lib/aarch64-linux-gnu/libcublas.so /usr/local/cuda/targets/aarch64-linux/lib/stubs/libcublas.so

# install qt5-dev
RUN mkdir -p /root/build_qt5 && \
    cd /root/build_qt5 && \
    wget https://download.qt.io/archive/qt/5.9/5.9.5/single/qt-everywhere-opensource-src-5.9.5.tar.xz && \
    tar -xvf qt-everywhere-opensource-src-5.9.5.tar.xz
COPY scripts/configure_qt5.sh /root/build_qt5/qt-everywhere-opensource-src-5.9.5
RUN cd /root/build_qt5/qt-everywhere-opensource-src-5.9.5 && \
    ./configure_qt5.sh && \
    make -j$(nproc) && \
    make install -j$(nproc) &&\
    rm -rf /root/build_qt5

WORKDIR /