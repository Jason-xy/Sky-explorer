#!/bin/bash
SCRIPTDIR=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null && pwd)
cd $SCRIPTDIR

VERSION=$1
docker run \
    --name="build-opencv-${VERSION}" \
    -v $SCRIPTDIR/../scripts:/root/scripts \
    --rm  jasonxxxyyy/jetson-cross-compile:jetpack4.6.2-cuda10.2-ubuntu1804-latest \
    bash -c " \
        cd /root/scripts && \
        chmod +x build_OpenCV.sh && \
        ./build_OpenCV.sh $VERSION && \
        cp /root/build_OpenCV/opencv-${VERSION}/build_aarch64_cuda/OpenCV-unknown-aarch64.sh /root/scripts/OpenCV-${VERSION}-cuda10.2-aarch64.sh && \
        chmod 777 /root/scripts/OpenCV-${VERSION}-cuda10.2-aarch64.sh"