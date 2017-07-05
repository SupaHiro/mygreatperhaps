#!/usr/bin/env bash

'
**Module**:
       :platform: CentOS
       :synopsis: CentOS-Nagios build for AWS EC2 & DigitalOcean

.. moduleauthor:: OccamsReiza

.. note::
    * This user data script does the following on launch:
    - Download and Compile Nagios Core
    - Download and Install Nagios Plugins
'
# update Yum and install requirements

yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release unzip httpd php gd gd-devel
yum install -y perl-Net-SNMP

# Download & Compile Nagios Core & Plugins
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.2.tar.gz
tar xzf nagioscore.tar.gz
cd /tmp/nagioscore-nagios-4.3.2/
./configure
make all

# Install Binaries
make install

# Install Command Mode & Default Configs

make install-commandmode
make install-config
make install-webconf
make install-init

TODO htpasswd base64 encoded silent config

# Start Services
systemctl enable nagios.service httpd.service
systemctl enable httpd.service

# Install Plugins
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar zxf nagios-plugins.tar.gz
cd /tmp/nagios-plugins-release-2.2.1/
./tools/setup
./configure
make
make install

# Create Users
useradd nagios
usermod -a -G nagios apache


# Firewall Rules
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --add-port=80/tcp
firewall-cmd --zone=public --add-port=80/tcp --permanent

# restart and check external ip
curl icanhazip.com > /tmp/externalip.txt
shutdown -r

