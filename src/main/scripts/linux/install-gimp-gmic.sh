#!/bin/bash

# G'MIC Installation Script for Ubuntu and Raspberry Pi (Raspbian OS)
# This script installs GIMP and the G'MIC plugin on Ubuntu or Raspberry Pi

echo "Starting G'MIC installation..."

# Step 1: Detect OS using the external script
OS=$(./detect_os.sh)

echo "Detected OS: $OS"

# Step 3: Update and upgrade package lists
echo "Updating package lists..."
sudo apt-get update && sudo apt-get upgrade -y

# Step 4: Install GIMP if not installed
if ! command -v gimp &> /dev/null; then
    echo "GIMP not found. Installing GIMP..."
    sudo apt-get install gimp -y
else
    echo "GIMP is already installed."
fi

# Step 5: Install G'MIC and G'MIC plugin for GIMP
echo "Installing G'MIC and G'MIC Plugin for GIMP..."
sudo apt-get install gmic gimp-gmic -y

# Step 6: Verify installation
if command -v gmic &> /dev/null && [ -f /usr/lib/gimp/2.0/plug-ins/gmic_gimp_qt ]; then
    echo "G'MIC and G'MIC Plugin for GIMP installed successfully."
else
    echo "Installation failed. Please check the logs for details."
    exit 1
fi

# Step 7: Display G'MIC version
gmic --version

echo "Installation complete! You can now use G'MIC in GIMP under Filters → G’MIC-Qt."
