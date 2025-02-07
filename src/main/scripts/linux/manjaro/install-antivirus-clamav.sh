#!/bin/bash

# Install ClamAV on Manjaro Linux

# Update the package database
sudo pacman -Syu --noconfirm

# Install ClamAV
sudo pacman -S --noconfirm clamav

# Enable and start the Freshclam service for automatic database updates
sudo systemctl enable clamav-freshclam.service
sudo systemctl start clamav-freshclam.service

# Enable and start the ClamAV daemon
sudo systemctl enable clamav-daemon.service
sudo systemctl start clamav-daemon.service

# Check ClamAV daemon status
sudo systemctl status clamav-daemon.service

# Stop ClamAV daemon before manually updating the virus database
sudo systemctl stop clamav-daemon.service

# Manually update the virus database
sudo freshclam

# Restart the ClamAV daemon
sudo systemctl start clamav-daemon.service

# Print success message
echo "ClamAV installation and setup completed successfully on Manjaro."
