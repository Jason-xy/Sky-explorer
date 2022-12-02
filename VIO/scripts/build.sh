#!/bin/bash
script_dir=$(cd $(dirname $0);pwd)
cd $script_dir

export PATH=$script_dir/../tools/cmake/bin:$PATH

mkdir -p ../catkin_temp_ws
cd ../catkin_temp_ws
source /opt/ros/noetic/setup.bash

catkin config -s $script_dir/../src --cmake-args -DCMAKE_TOOLCHAIN_FILE=$script_dir/toolchain/toolchain.cmake --
catkin build camera_models