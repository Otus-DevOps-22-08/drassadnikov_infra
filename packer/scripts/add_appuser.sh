#!/bin/bash
echo 'add user'
sudo useradd -m -d /home/appuser -s /bin/bash appuser
sudo su - appuser
mkdir -p /home/appuser/.ssh
touch .ssh/authorized_keys
echo "ssh-rsa" > /home/appuser/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
