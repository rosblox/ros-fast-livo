#!/bin/bash

xhost +

docker run -it --rm --privileged --net=host \
--volume $(pwd)/FAST-LIVO:/catkin_ws/src/FAST-LIVO \
--volume $(pwd)/livox_ros_driver:/catkin_ws/src/livox_ros_driver \
--volume $(pwd)/rpg_vikit:/catkin_ws/src/rpg_vikit \
-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
ghcr.io/rosblox/ros-fast-livo:noetic

