# --gpus all: Use all GPUs through nvidia-docker
# -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix: Use X11 to display GUI
image_name="jasonxxxyyy/sky-explorer:runtime-cuda11.4-ros2-amd64"
docker run -ti --rm --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $image_name  /bin/bash