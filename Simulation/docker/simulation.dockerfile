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

RUN apt-get update && \
    apt-get install -y \
    ros-noetic-mavros \
    ros-noetic-mavros-extras

USER docker:docker
RUN /tmp/Tools/setup/ubuntu.sh
ENTRYPOINT ["fixuid"]