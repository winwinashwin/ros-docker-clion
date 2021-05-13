# Simulation environment for running UI based nodes and development involving the same.
# Depends on : nvidia-docker2
#
# Author: Ashwin A Nayar    [github.com/nocoinman]

FROM osrf/ros:melodic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive
ARG ROS_WS=/catkin_ws

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get update \
  && apt-get install -y \
      build-essential \
      psmisc \
      vim-gtk \
      python-catkin-tools \
      python-pip \
  && rm -rf /var/lib/apt/lists/*

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
COPY config/ros_global.sh /etc/profile.d/ros_global.sh

RUN apt-get update \
  && apt-get install -y \
      ros-melodic-hector-gazebo-plugins \
  && rm -rf /var/lib/apt/lists/*
