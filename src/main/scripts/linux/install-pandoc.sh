#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Pandoc is installed
if command_exists pandoc; then
    echo "Pandoc is already installed: $(pandoc --version | head -n 1)"
    exit 0
fi

echo "Pandoc is not installed. Attempting to install it..."

# Detect the package manager and install Pandoc
if [[ -f /etc/debian_version ]]; then
    # Debian-based (Ubuntu, Debian)
    sudo apt update && sudo apt install -y pandoc
elif [[ -f /etc/arch-release ]]; then
    # Arch Linux
    sudo pacman -Syu --noconfirm pandoc
elif [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    if command_exists brew; then
        brew install pandoc
    else
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
else
    echo "Unsupported operating system. Please install Pandoc manually: https://pandoc.org/installing.html"
    exit 1
fi

# Verify if the installation was successful
if command_exists pandoc; then
    echo "Pandoc successfully installed: $(pandoc --version | head -n 1)"
else
    echo "Pandoc installation failed. Please try installing it manually."
    exit 1
fi
