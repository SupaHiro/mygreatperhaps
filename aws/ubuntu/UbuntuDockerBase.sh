#!/bin/bash
'

**Module**:
       :platform: Ubuntu
       :synopsis: AWS Lightsail

.. moduleauthor:: OccamsReiza

.. note::
    * This user data script does the following on launch:
    - Create Docker user
    - Create Docker group
    - Install Docker
'

apt update -y

# Add required utilities
apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Create Docker user
adduser docker --disabled-password
usermod -aG docker docker

# Accept Docker Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88

# Add stable Docker repo
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update apt & install Docker
apt update -y
apt install docker-ce
systemctl start docker

# Enable on boot
systemctl enable docker
apt upgrade -y

# Add docker user to group and verify run
su - docker
docker run hello-world

# restart and check external ip
curl icanhazip.com > /tmp/externalip.txt
shutdown -r