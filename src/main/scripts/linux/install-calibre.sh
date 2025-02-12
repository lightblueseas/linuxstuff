#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Calibre is already installed
if command_exists calibre; then
    echo "Calibre is already installed: $(calibre --version)"
    exit 0
fi

echo "Calibre is not installed. Attempting to install it..."

# Detect the package manager and install Calibre
if [[ -f /etc/debian_version ]]; then
    # Debian-based (Ubuntu, Debian)
    sudo apt update && sudo apt install -y calibre
elif [[ -f /etc/arch-release ]]; then
    # Arch Linux (Manjaro, Arch)
    sudo pacman -Syu --noconfirm calibre
elif [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    if command_exists brew; then
        brew install --cask calibre
    else
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
else
    echo "Unsupported operating system. Please install Calibre manually: https://calibre-ebook.com/download"
    exit 1
fi

# Verify if the installation was successful
if command_exists calibre; then
    echo "Calibre successfully installed: $(calibre --version)"
else
    echo "Calibre installation failed. Please try installing it manually."
    exit 1
fi
