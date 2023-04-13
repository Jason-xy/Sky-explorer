#!/bin/bash
script_dir=$(cd $(dirname $0);pwd)
docker build -f $script_dir/simulation.dockerfile -t jasonxxxyyy/sky-explorer:runtime-cuda11.4-ros1-simulation-amd64 $script_dir/../../