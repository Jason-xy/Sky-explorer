#!/bin/bash
script_dir=$(cd $(dirname $0);pwd)
docker run --gpus all --rm -it \
        --name Simulation \
        --privileged \
        --network host \
        -u $(id -u):$(id -g) \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix/:/tmp/.X11-unix \
        -v $script_dir/../../:/home/docker/sky-explorer \
        jasonxxxyyy/sky-explorer:runtime-cuda11.4-ros1-simulation-amd64 \
       	/bin/bash