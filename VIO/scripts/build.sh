#!/bin/bash
script_dir=$(cd $(dirname $0);pwd)
cd $script_dir

export PATH=$script_dir/../tools/cmake/bin:$PATH

mkdir -p ../catkin_temp_ws
cd ../catkin_temp_ws
source /opt/ros/noetic/setup.bash

mkdir -p src && rm -rf src/*
cp -r $script_dir/../src/* src/
cd src && catkin_init_workspace
cd ..

catkin_make