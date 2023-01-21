FROM ros:noetic-ros-core

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential wget \
    ros-${ROS_DISTRO}-cv-bridge  \
    ros-${ROS_DISTRO}-eigen-conversions \
    ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-rviz \
    ros-${ROS_DISTRO}-image-transport* \ 
    libfmt-dev \
    && rm -rf /var/lib/apt/lists/*


COPY Sophus Sophus
WORKDIR /Sophus/build
RUN cmake .. && make && make install


WORKDIR /catkin_ws/src

COPY rpg_vikit rpg_vikit
COPY FAST-LIVO FAST-LIVO
COPY livox_ros_driver livox_ros_driver

WORKDIR /catkin_ws

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && catkin_make

WORKDIR /

COPY resources/ros_entrypoint.sh .

# Download bag file
ARG GDRIVE_BAGFILE_ID=1sscaSyLong5mPdONVfDabjU51a77NZSB
ARG GDRIVE_BAGFILE_NAME=hku2.bag
ENV GDRIVE_BAGFILE_NAME=${GDRIVE_BAGFILE_NAME}

RUN wget -q --load-cookies /tmp/cookies.txt \ 
    "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$GDRIVE_BAGFILE_ID' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$GDRIVE_BAGFILE_ID" -O $GDRIVE_BAGFILE_NAME && rm -rf /tmp/cookies.txt


WORKDIR /catkin_ws

RUN echo 'alias build="catkin_make"' >> ~/.bashrc
RUN echo 'alias run="roslaunch fast_livo docker_mapping_avia.launch"' >> ~/.bashrc
