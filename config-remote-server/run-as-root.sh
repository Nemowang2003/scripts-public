#!/bin/bash

user=$1
port=$2
mirror=$3

# install helix, zsh, etc.
add-apt-repository ppa:maveonair/helix-editor -y
apt install helix zsh python3-pip python3-pylsp curl bat tree -y

# add user
adduser --shell `which zsh` --gecos '' --disabled-password $user

# add sudoer
echo -e "$user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user

# user level
sudo -u $user bash run-as-user.sh $mirror

# sshd config
ufw allow ssh
ufw allow $port/tcp
ufw enable
echo Port $port >> /etc/ssh/sshd_config.d/${user}.conf
systemctl restart sshd
