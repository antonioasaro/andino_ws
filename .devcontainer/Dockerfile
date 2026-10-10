FROM osrf/ros:humble-desktop-full

ARG USER=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive
ENV WORKSPACE=/home/${USER}/andino_ws
SHELL ["/bin/bash", "-c"]

# Create workspace as root
RUN mkdir -p ${WORKSPACE}/src

# Install core administrative dependencies (including sudo)
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    dos2unix \
    sudo \
    ca-certificates \
    libserial-dev

# Create user and group if they don't exist, matching host UID/GID
RUN getent group $USER_GID || groupadd --gid $USER_GID ${USER} \
    && getent passwd $USER_UID || useradd --uid $USER_UID --gid $USER_GID -m ${USER}

# Add passwordless sudo privileges cleanly via sudoers.d
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

# Install dependencies from requirements.txt
COPY requirements.txt .
RUN dos2unix requirements.txt && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    $(cat requirements.txt) && \
    apt-get clean && rm -rf /var/lib/apt/lists/* requirements.txt

# Install fixuid
RUN curl -fSsL https://github.com/boxboat/fixuid/releases/download/v0.6.0/fixuid-0.6.0-linux-amd64.tar.gz \
    | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: ${USER}\ngroup: ${USER}\n" > /etc/fixuid/config.yml

# Ensure ROS dependencies initialized
RUN rosdep init || true

# Add user to groups for serial access
RUN usermod -a -G dialout,plugdev,sudo ${USER}

# Ensure proper ownership of workspace and home folder
RUN chown -R ${USER}:${USER} /home/${USER}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${USER}

# Source workspace automatically (escaped $ROS_DISTRO to read dynamically at runtime)
RUN echo ". /opt/ros/\${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    echo ". ${WORKSPACE}/install/setup.bash" >> ~/.bashrc && \
    echo "source ~/.bash_aliases" >> ~/.bashrc

WORKDIR ${WORKSPACE}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

