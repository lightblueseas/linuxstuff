#!/usr/bin/env bash

# Audacious Installation Script for Multiple OS
# This script installs Audacious and its plugins based on the detected OS

# Step 1: Detect OS using the external script
OS=$(./detect_os.sh)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    echo "Could not detect the OS or unsupported OS detected."
    exit 1
fi

echo "Detected OS: $OS"

# Step 2: Install Audacious based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        echo "Updating package database for $OS..."
        sudo apt-get update -y

        echo "Installing Audacious on $OS..."
        sudo apt-get install -y audacious audacious-plugins
        ;;

    manjaro|arch)
        echo "Updating package database for $OS..."
        pamac update --force-refresh

        echo "Installing Audacious on $OS..."
        pamac install --no-confirm audacious audacious-plugins
        ;;

    fedora)
        echo "Updating package database for $OS..."
        sudo dnf update -y

        echo "Installing Audacious on $OS..."
        sudo dnf install -y audacious audacious-plugins
        ;;

    centos|redhat)
        echo "Updating package database for $OS..."
        sudo yum update -y

        echo "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        echo "Installing Audacious on $OS..."
        sudo yum install -y audacious audacious-plugins
        ;;

    opensuse)
        echo "Updating package database for $OS..."
        sudo zypper refresh

        echo "Installing Audacious on $OS..."
        sudo zypper install -y audacious audacious-plugins
        ;;

    alpine)
        echo "Updating package database for $OS..."
        sudo apk update

        echo "Installing Audacious on $OS..."
        sudo apk add audacious audacious-plugins
        ;;

    macos)
        if command -v brew &> /dev/null; then
            echo "Homebrew is installed. Updating..."
            brew update

            echo "Installing Audacious on macOS..."
            brew install audacious
        else
            echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        echo "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            echo "Installing Audacious via snap..."
            sudo snap install audacious
        else
            echo "Snap is not installed. Please install Snap or use your package manager to install Audacious."
            exit 1
        fi
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
echo "Verifying Audacious installation..."
if command -v audacious &> /dev/null; then
    echo "✅ Audacious installed successfully."
else
    echo "❌ Audacious installation failed. Please check for errors."
    exit 1
fi

echo "Audacious installation completed successfully on $OS."
