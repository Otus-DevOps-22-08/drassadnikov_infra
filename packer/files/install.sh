#!/bin/bash
sudo apt install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
dir=$(pwd)
sudo cat << EOF > /etc/systemd/system/puma.service
[Unit]
Description=Puma HTTP Server
After=network.target
[Service]
Type=simple
WorkingDirectory=$dir
ExecStart=/usr/local/bin/puma
Restart=always
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable puma.service
sudo systemctl start puma.service
systemctl status puma.service
