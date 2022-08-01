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
cd
# Create service file
sudo touch /etc/systemd/system/prometheus.service
sudo cp /prometheus-installation-scripts/prometheus.service /etc/systemd/system/

# Reloading System
sudo systemctl daemon-reload

sudo systemctl enable prometheus

sudo systemctl start prometheus

# enable prometheus service in firewall or AWS security group
# sudo firewall-cmd --add-service=prometheus --permanent
# sudo firewall-cmd --reload