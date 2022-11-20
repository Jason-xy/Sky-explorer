#!/bin/bash
# download opencv
# Usage: ./build_OpenCV <version>
VERSION=$1
mkdir -p $HOME/build_OpenCV
cd $HOME/build_OpenCV

# download OpenCV package
curl -o opencv.zip -L https://github.com/opencv/opencv/archive/$VERSION.zip
unzip opencv

# download contrib package
curl -o ./opencv_extra_$VERSION.zip https://codeload.github.com/opencv/opencv_contrib/zip/$VERSION
unzip opencv_extra_$VERSION.zip

cd opencv-$VERSION

mkdir build_aarch64_cuda
cd build_aarch64_cuda

echo 'set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")' | cat - ../cmake/OpenCVDetectCUDA.cmake > temp && mv temp ../cmake/OpenCVDetectCUDA.cmake

cmake   -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda/targets/aarch64-linux \
        -DCMAKE_TOOLCHAIN_FILE=../platforms/linux/aarch64-gnu.toolchain.cmake \
        -DCMAKE_LIBRARY_PATH=/usr/local/cuda/targets/aarch64-linux/lib/stubs \
        -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$VERSION/modules \
        -DWITH_CUDA=ON \
        -DCUDA_NVCC_FLAGS="--expt-relaxed-constexpr"
        -DENABLE_FAST_MATH=ON \
        -DCUDA_FAST_MATH=ON \
        -DWITH_CUBLAS=ON \
        -DWITH_LIBV4L=ON \
        -Dopencv_cudev=ON \
        -DCUDA_ARCH_BIN='5.3 6.2 7.2' \
        -DBUILD_opencv_cudev=ON \
        -DWITH_CAROTENE=OFF \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DBUILD_DOCS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_opencv_apps=OFF \
        -DBUILD_opencv_python2=OFF \
        -DBUILD_opencv_python3=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_TESTS=OFF \
        -DFORCE_VTK=OFF \
        -DWITH_FFMPEG=OFF \
        -DWITH_GDAL=OFF \
        -DWITH_IPP=OFF \
        -DWITH_OPENEXR=OFF \
        -DWITH_OPENGL=ON \
        -DWITH_QT=ON \
        -DWITH_TBB=ON \
        -DWITH_XINE=OFF \
        -DBUILD_JPEG=ON \
        -DBUILD_ZLIB=ON \
        -DBUILD_PNG=ON \
        -DBUILD_TIFF=ON \
        -DBUILD_BUILD_JASPER=OFF \
        -DWITH_ITT=OFF \
        -DWITH_LAPACK=OFF \
        -DWITH_OPENCL=OFF \
        -DWITH_TIFF=ON \
        -DWITH_PNG=ON \
        -DWITH_OPENCLAMDFFT=OFF \
        -DWITH_OPENCLAMDBLAS=OFF \
        -DWITH_VA_INTEL=OFF \
        -DWITH_WEBP=OFF \
        -DWITH_JASPER=OFF ..

make -j$(nproc)
