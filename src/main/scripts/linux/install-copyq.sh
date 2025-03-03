#!/bin/bash

# CopyQ Installation Script for Multiple OS
# This script installs CopyQ based on the detected OS

# Step 1: Detect OS using the external script
OS=$(./detect_os.sh)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    echo "Could not detect the OS or unsupported OS detected."
    exit 1
fi

echo "Detected OS: $OS"

# Step 2: Install CopyQ based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        echo "Updating package database for $OS..."
        sudo apt-get update

        echo "Installing CopyQ on $OS..."
        sudo apt-get install -y copyq
        ;;

    manjaro|arch)
        echo "Updating package database for $OS..."
        pamac update --force-refresh

        echo "Installing CopyQ on $OS..."
        pamac install --no-confirm copyq
        ;;

    fedora)
        echo "Updating package database for $OS..."
        sudo dnf update -y

        echo "Installing CopyQ on $OS..."
        sudo dnf install -y copyq
        ;;

    centos|redhat)
        echo "Updating package database for $OS..."
        sudo yum update -y

        echo "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        echo "Installing CopyQ on $OS..."
        sudo yum install -y copyq
        ;;

    opensuse)
        echo "Updating package database for $OS..."
        sudo zypper refresh

        echo "Installing CopyQ on $OS..."
        sudo zypper install -y copyq
        ;;

    alpine)
        echo "Updating package database for $OS..."
        sudo apk update

        echo "Installing CopyQ on $OS..."
        sudo apk add copyq
        ;;

    macos)
        if command -v brew &> /dev/null; then
            echo "Homebrew is installed. Updating..."
            brew update

            echo "Installing CopyQ on macOS..."
            brew install copyq
        else
            echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        echo "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            echo "Installing CopyQ via snap..."
            sudo snap install copyq
        else
            echo "Snap is not installed. Please install Snap or use your package manager to install CopyQ."
            exit 1
        fi
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
echo "Verifying CopyQ installation..."
if command -v copyq &> /dev/null; then
    echo "✅ CopyQ installed successfully."
else
    echo "❌ CopyQ installation failed. Please check for errors."
    exit 1
fi
