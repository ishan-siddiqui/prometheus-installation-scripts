#!/bin/bash
echo "Installing pormetheus on this AWS instance.."
# Create the directories in which we will be storing our configuration files and libraries
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
# Set the ownership of the /var/lib/prometheus directory 
sudo chown ec2-user:ec2-user /var/lib/prometheus
cd /tmp/
# Downloading prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.31.1/prometheus-2.31.1.linux-amd64.tar.gz
tar -xvf prometheus-2.31.1.linux-amd64.tar.gz
cd prometheus-2.31.1.linux-amd64
# Move the configuration file and set the owner
sudo mv console* /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
sudo chown -R ec2-user:ec2-user /etc/prometheus
# Move the binaries and set the owner
sudo mv prometheus /usr/local/bin/
sudo chown ec2-user:ec2-user /usr/local/bin/prometheus
# Create service file
sudo touch /etc/systemd/system/prometheus.service
sudo cat << EOF >> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus for AWS
Wants=network-online.target
After=network-online.target
[Service]
User=ec2-user
Group=ec2-user
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries
[Install]
WantedBy=multi-user.target
EOF
# Reloading System
sudo systemctl daemon-reload

sudo systemctl enable prometheus

sudo systemctl start prometheus

# enable prometheus service in firewall or AWS security group
sudo firewall-cmd --add-service=prometheus --permanent
sudo firewall-cmd --reload