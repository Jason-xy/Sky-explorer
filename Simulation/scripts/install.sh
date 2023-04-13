sudo apt-get remove -y gazebo*
sudo apt-get remove -y libgazebo*
sudo apt-get remove -y ros-noetic-gazebo*
sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y gazebo9 libgazebo9-dev python3-catkin-tools
sudo apt-get upgrade -y
sudo apt-get install ros-noetic-moveit-msgs ros-noetic-object-recognition-msgs ros-noetic-octomap-msgs ros-noetic-camera-info-manager  ros-noetic-control-toolbox ros-noetic-polled-camera ros-noetic-controller-manager ros-noetic-transmission-interface ros-noetic-joint-limits-interface
sudo apt install ros-noetic-mavros ros-noetic-mavros-extras
sudo apt-get install libgeographic-dev
sudo apt-get install geographiclib-tools
sudo apt-get install xmlstarlet