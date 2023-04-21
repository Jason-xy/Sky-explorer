FROM jasonxxxyyy/sky-explorer:runtime-cuda11.4-ros1-amd64

COPY FC/PX4-Autopilot/Tools /tmp/Tools

RUN addgroup --gid 1000 docker && \
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker

RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml && \
    usermod -a -G sudo docker && \
    echo "docker ALL=(ALL)NOPASSWD:ALL" >> /etc/sudoers

# install gazebo9
RUN apt-get remove -y gazebo* && \
    apt-get remove -y libgazebo* && \
    apt-get remove -y ros-noetic-gazebo* && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - && \
    apt-get update && \
    apt-get install -y gazebo9 libgazebo9-dev && \
    apt-get upgrade -y

RUN apt-get update && \
    apt-get install -y \
    ros-noetic-mavros \
    ros-noetic-mavros-extras \
    python3-catkin-tools

USER docker:docker
RUN /tmp/Tools/setup/ubuntu.sh
ENTRYPOINT ["fixuid"]