#!/bin/bash

# Detect OS
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
else
    echo "Could not determine OS. Exiting."
    exit 1
fi

if [[ "$ID" == "manjaro" ]]; then
    echo "Installing Zsh on Manjaro..."
    # Update package database
    sudo pacman -Sy --noconfirm
    # Install Zsh
    sudo pacman -S zsh --noconfirm
elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"debian"* ]]; then
    echo "Installing Zsh on Ubuntu..."
    # Update package database
    sudo apt update -y
    # Install Zsh
    sudo apt install zsh -y
else
    echo "Unsupported OS. Exiting."
    exit 1
fi

# Verify Zsh installation
zsh --version

# Set Zsh as the default shell
chsh -s $(which zsh)

# Verify the default shell change
echo "Your current shell is: $SHELL"

# Prompt user to log out or restart if needed
echo "If the output above is still /bin/bash, please log out or reboot."

echo "When you open Zsh for the first time, you may see a configuration menu."
echo "Follow the prompts to configure your shell."

echo "To verify again, run: echo \$SHELL"
