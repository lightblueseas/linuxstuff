#!/bin/bash

# G'MIC Installation Script for Manjaro Linux
# This script installs GIMP and the G'MIC plugin on Manjaro Linux

echo "Starting G'MIC installation for Manjaro Linux..."

# Step 1: Check if GIMP is installed
if ! command -v gimp &> /dev/null; then
    echo "GIMP not found. Installing GIMP..."
    sudo pacman -S gimp --noconfirm
else
    echo "GIMP is already installed."
fi

# Step 2: Check if yay (AUR helper) is installed
if ! command -v yay &> /dev/null; then
    echo "yay not found. Installing yay..."
    sudo pacman -S yay --noconfirm
else
    echo "yay is already installed."
fi

# Step 3: Install G'MIC and GIMP Plugin for G'MIC
echo "Installing G'MIC and GIMP Plugin for G'MIC..."
yay -S gmic gimp-plugin-gmic --noconfirm

# Step 4: Verify installation
if command -v gmic &> /dev/null && [ -f /usr/lib/gimp/2.0/plug-ins/gmic_gimp_qt ]; then
    echo "G'MIC and G'MIC Plugin for GIMP installed successfully."
else
    echo "Installation failed. Please check the logs for details."
    exit 1
fi

# Step 5: Display G'MIC version
gmic --version

echo "Installation complete! You can now use G'MIC in GIMP under Filters → G’MIC-Qt."
