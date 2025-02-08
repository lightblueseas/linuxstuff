#!/bin/bash

# Update package database
sudo pacman -Sy --noconfirm

# Install Zsh
sudo pacman -S zsh --noconfirm

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
