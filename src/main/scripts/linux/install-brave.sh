#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Brave Browser is already installed
if command_exists brave-browser; then
    echo "Brave Browser is already installed: $(brave-browser --version 2>/dev/null)"
    exit 0
fi

echo "Brave Browser is not installed. Attempting to install it..."

# Detect the package manager and install Brave Browser
if [[ -f /etc/debian_version ]]; then
    # Debian-based (Ubuntu, Debian, Mint)
    echo "Detected Debian-based system."
    if ! command_exists curl; then
        echo "curl is required to install Brave on Debian/Ubuntu. Please install curl first (e.g., sudo apt install curl) and run this script again."
        exit 1
    fi
    if ! command_exists apt-transport-https; then
        echo "apt-transport-https is required. Installing it..."
        sudo apt update && sudo apt install -y apt-transport-https
    fi

    echo "Adding Brave Browser repository..."
    curl -s https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-archive-keyring.gpg add -
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    echo "Updating package lists and installing Brave Browser..."
    sudo apt update && sudo apt install -y brave-browser

elif [[ -f /etc/arch-release ]]; then
    # Arch Linux
    echo "Detected Arch Linux."
    if command_exists yay; then
        echo "Using yay to install Brave Browser..."
        yay -S brave-browser --noconfirm
    elif command_exists paru; then
        echo "Using paru to install Brave Browser..."
        paru -S brave-browser --noconfirm
    else
        echo "Neither yay nor paru (AUR helpers) are installed. Please install one (e.g., sudo pacman -S yay) or install Brave Browser manually from AUR."
        exit 1
    fi

elif [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    echo "Detected macOS."
    if command_exists brew; then
        echo "Using Homebrew to install Brave Browser..."
        brew install --cask brave-browser
    else
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi

else
    echo "Unsupported operating system. Please install Brave Browser manually from: https://brave.com/download/"
    exit 1
fi

# Verify if the installation was successful
if command_exists brave-browser; then
    echo "Brave Browser successfully installed: $(brave-browser --version 2>/dev/null)"
else
    echo "Brave Browser installation failed. Please try installing it manually from: https://brave.com/download/"
    exit 1
fi

echo "Installation process completed."