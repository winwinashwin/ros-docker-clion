# Creates a simple sandbox environment.
#
# WARNING: This image does not support UI based nodes/development.
#
# Author: Ashwin A Nayar    [github.com/nocoinman]

FROM ros:melodic

ARG DEBIAN_FRONTEND=noninteractive
ARG L_PREV_USR=rosdev
# TODO: You might want to use a strong password here
ARG L_PREV_PWD=peekaboo1729
ARG ROS_WS=/home/${L_PREV_USR}/catkin_ws

RUN apt-get update \
  && apt-get install -y ssh \
      build-essential \
      gcc \
      g++ \
      gdb \
      clang \
      cmake \
      rsync \
      tar \
      python \
      wget \
  && rm -rf /var/lib/apt/lists/*

# Adding a low-privilege user for CLion to SSH
RUN groupadd -r ${L_PREV_USR}
RUN useradd -m -r -g ${L_PREV_USR} ${L_PREV_USR} && yes ${L_PREV_PWD} | passwd ${L_PREV_USR}
RUN mkdir -p ${ROS_WS} && chown -R ${L_PREV_USR} /home/${L_PREV_USR}

# Contains environment variables permanent for all users in the container
COPY config/ros_global.sh /etc/profile.d/ros_global.sh

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_test_clion \
  && mkdir /run/sshd

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_test_clion"]
