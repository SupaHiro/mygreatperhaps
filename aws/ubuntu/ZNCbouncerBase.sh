#!/usr/bin/env

'

**Module**:
       :platform: Ubuntu
       :synopsis: ZNC build for Ubuntu

.. moduleauthor:: OccamsReiza

.. note::
    * This user data script does the following on launch:
    - Create Docker user
    - Create Docker group
    - Install Docker
'

# update apt and install requirements
apt update
apt install -y build-essential libssl-dev libperl-dev pkg-config

#Install ZNC
cd /usr/local/src; sudo wget http://znc.in/releases/znc-latest.tar.gz

sudo tar -xzvf znc-latest.tar.gz; cd znc*
./congifure
sudo make; sudo make install

#Create ZNC admin
adduser znc-admin
su znc-admin; cd ~

