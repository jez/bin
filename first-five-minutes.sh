#!/bin/bash

# https://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers
#
# TODO(jez) Automate passwords
#

set -euo pipefail

echo 'Creating password for root...'
passwd

apt-get update
apt-get upgrade -y

apt-get install -y fail2ban unattended-upgrades

useradd jez

mkdir -p /home/jez/.ssh
chmod 700 /home/jez/.ssh
cp .ssh/authorized_keys /home/jez/.ssh/
chmod 400 /home/jez/.ssh/authorized_keys
touch /home/jez/.hushlogin
chown -R jez:jez /home/jez -R

echo 'Creating password for jez...'
passwd jez

echo 'jez    ALL=(ALL:ALL) ALL' > /etc/sudoers.d/jez
chmod 440 /etc/sudoers.d/jez

chsh -s /bin/bash jez

sed -i -e 's/^PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config
service ssh restart

ufw default deny incoming
ufw default allow outgoing
ufw allow 22
ufw --force enable

echo 'APT::Periodic::Update-Package-Lists "1";'          >  /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::AutocleanInterval "7";'             >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Unattended-Upgrade "1";'            >> /etc/apt/apt.conf.d/10periodic

sed -i -e 's+^\s*"\${distro_id}:\${distro_codename}";.*$+//\t"\${distro_id}:\${distro_codename}"+' /etc/apt/apt.conf.d/50unattended-upgrades
