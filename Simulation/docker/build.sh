#!/bin/bash
script_dir=$(cd $(dirname $0);pwd)
docker build -f $script_dir/simulation.dockerfile -t jasonxxxyyy/sky-explorer:runtime-cuda11.4-ros1-simulation-amd64 $script_dir/../../ --build-arg "https_proxy=http://172.27.64.1:7890" --build-arg "http_proxy=http://172.27.64.1:7890"