#!/usr/bin/env bash

# Calibre Installation Script for Multiple OS
# This script installs Calibre based on the detected OS

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Source the common initialization script
source ./init_scripts.sh

# Check if Calibre is already installed
if command_exists calibre; then
    echo "Calibre is already installed: $(calibre --version)"
    exit 0
fi

echo "Calibre is not installed. Attempting to install it..."

# Step 2: Install Calibre based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        echo "Detected Debian-based system."
        sudo apt-get update -y
        echo "Installing Calibre on $OS..."
        sudo apt-get install -y calibre
        ;;

    manjaro|arch)
        echo "Detected Arch-based system."
        echo "Updating package database..."
        pamac update --force-refresh
        echo "Installing Calibre on $OS..."
        pamac install --no-confirm calibre
        ;;

    fedora)
        echo "Detected Fedora system."
        sudo dnf update -y
        echo "Installing Calibre on Fedora..."
        sudo dnf install -y calibre
        ;;

    centos|redhat)
        echo "Detected CentOS/Red Hat system."
        sudo yum update -y
        echo "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release
        echo "Installing Calibre on $OS..."
        sudo yum install -y calibre
        ;;

    opensuse)
        echo "Detected openSUSE system."
        sudo zypper refresh
        echo "Installing Calibre on openSUSE..."
        sudo zypper install -y calibre
        ;;

    alpine)
        echo "Detected Alpine Linux."
        sudo apk update
        echo "Installing Calibre on Alpine Linux..."
        sudo apk add calibre
        ;;

    macos)
        if command_exists brew; then
            echo "Using Homebrew to install Calibre..."
            brew install --cask calibre
        else
            echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;

    linux)
        echo "Detected a generic Linux distribution. Attempting to install via snap..."
        if command_exists snap; then
            echo "Installing Calibre via snap..."
            sudo snap install calibre
        else
            echo "Snap is not installed. Please install Snap or use your package manager to install Calibre."
            exit 1
        fi
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
echo "Verifying Calibre installation..."
if command_exists calibre; then
    echo "✅ Calibre successfully installed: $(calibre --version)"
else
    echo "❌ Calibre installation failed. Please try installing it manually: https://calibre-ebook.com/download"
    exit 1
fi

echo "Calibre installation completed successfully on $OS."
