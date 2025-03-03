#!/bin/bash

# Detect OS
ID=""  # Set ID to an empty string if /etc/os-release is not found

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
elif [[ -f /etc/rpi-issue ]]; then
    # Fallback for older Raspberry Pi OS versions
    ID="raspbian"
else
    echo "Could not determine OS file. Continuing with ID as empty string."
fi

# Check for Raspberry Pi OS explicitly
if grep -qi 'raspbian' /etc/os-release 2>/dev/null; then
    ID="raspbian"
fi

echo "Detected OS: ${ID:-unknown}"

if [[ "$ID" == "manjaro" ]]; then
    echo "Installing Zsh on Manjaro..."
    # Update package database
    sudo pacman -Sy --noconfirm
    # Install Zsh
    sudo pacman -S zsh --noconfirm

elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"debian"* ]]; then
    echo "Installing Zsh on Ubuntu/Debian..."
    # Update package database
    sudo apt-get update -y
    # Install Zsh
    sudo apt-get install zsh -y

elif [[ "$ID" == "raspbian" || ( "$ID" == "debian" && "$(uname -m)" == *"arm"* ) ]]; then
    echo "Installing Zsh on Raspberry Pi OS..."
    # Update package database
    sudo apt-get update -y
    # Install Zsh
    sudo apt-get install zsh -y

elif [[ -z "$ID" ]]; then
    echo "OS could not be detected, proceeding without OS-specific package management."
    if command -v apt-get &> /dev/null; then
        echo "Attempting to install Zsh using apt-get..."
        sudo apt-get update -y
        sudo apt-get install zsh -y
    elif command -v pacman &> /dev/null; then
        echo "Attempting to install Zsh using pacman..."
        sudo pacman -Sy --noconfirm
        sudo pacman -S zsh --noconfirm
    else
        echo "No known package manager found. Exiting."
        exit 1
    fi

else
    echo "Unsupported OS. Exiting."
    exit 1
fi

# Verify Zsh installation
if ! command -v zsh &> /dev/null; then
    echo "Zsh installation failed. Exiting."
    exit 1
fi

zsh --version

# Set Zsh as the default shell
ZSH_PATH=$(which zsh)
if [[ -z "$ZSH_PATH" ]]; then
    echo "Zsh not found in PATH. Exiting."
    exit 1
fi

echo "Setting Zsh as default shell for user: $USER"
sudo chsh -s "$ZSH_PATH" "$USER"

# Verify the default shell change
echo "Your current shell is: $SHELL"

# Prompt user to log out or restart if needed
echo "If the output above is still /bin/bash, please log out or reboot."

echo "When you open Zsh for the first time, you may see a configuration menu."
echo "Follow the prompts to configure your shell."

echo "To verify again, run: echo \$SHELL"
