#!/usr/bin/env bash

# Antivirus program ClamAV installation on Ubuntu

# Update the package list
sudo apt update -y

# Install ClamAV and related packages
sudo apt-get install -y clamav
sudo apt-get install -y clamav-freshclam
sudo apt-get install -y clamav-docs
sudo apt-get install -y clamav-daemon
sudo apt-get install -y clamtk
sudo apt-get install -y clamtk-nautilus

# Enable and start the ClamAV daemon
sudo systemctl enable clamav-daemon
sudo systemctl start clamav-daemon

# Check ClamAV daemon status
sudo systemctl status clamav-daemon

# Stop ClamAV daemon before manually updating the virus database
sudo systemctl stop clamav-daemon

# Manually update the virus database
sudo freshclam

# Restart the ClamAV daemon
sudo systemctl start clamav-daemon

# Print success message
echo "ClamAV installation and setup completed successfully on Ubuntu."
