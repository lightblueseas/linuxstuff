#!/bin/bash

# Install Zsh if not installed
if ! command -v zsh &> /dev/null; then
    echo "Zsh not found. Installing Zsh..."
    sudo apt-get install -y zsh
else
    echo "Zsh is already installed."
fi

# Install curl or wget if not installed
if command -v curl &> /dev/null; then
    echo "Using curl to install Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
elif command -v wget &> /dev/null; then
    echo "curl not found. Using wget to install Oh-My-Zsh..."
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
else
    echo "Neither curl nor wget is installed. Installing curl..."
    sudo apt-get install -y curl
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Change default shell to Zsh
echo "Changing default shell to Zsh..."
chsh -s $(which zsh)

echo "Installation complete. Please restart your terminal."