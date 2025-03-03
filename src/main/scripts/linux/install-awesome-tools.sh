#!/usr/bin/env bash

# Utilities Installation Script for Multiple OS
# This script installs Baobab, Shutter, KTouch, and Shotwell based on the detected OS

# Step 1: Detect OS using the external script
OS=$(./detect_os.sh)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    echo "Could not detect the OS or unsupported OS detected."
    exit 1
fi

echo "Detected OS: $OS"

# Step 2: Install utilities based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        echo "Updating package database for $OS..."
        sudo apt-get update -y

        echo "Installing Baobab (Disk Usage Analyzer)..."
        sudo apt-get install -y baobab

        echo "Installing Shutter (Screenshot Tool)..."
        sudo apt-get install -y shutter

        echo "Installing KTouch (Typing Tutor)..."
        sudo apt-get install -y ktouch

        echo "Installing Shotwell (Photo Organizer)..."
        sudo apt-get install -y shotwell
        ;;

    manjaro|arch)
        echo "Updating package database for $OS..."
        pamac update --force-refresh

        echo "Installing Baobab (Disk Usage Analyzer)..."
        pamac install --no-confirm baobab

        echo "Installing Shutter (Screenshot Tool)..."
        pamac install --no-confirm shutter

        echo "Installing KTouch (Typing Tutor)..."
        pamac install --no-confirm ktouch

        echo "Installing Shotwell (Photo Organizer)..."
        pamac install --no-confirm shotwell
        ;;

    fedora)
        echo "Updating package database for $OS..."
        sudo dnf update -y

        echo "Installing Baobab (Disk Usage Analyzer)..."
        sudo dnf install -y baobab

        echo "Installing Shutter (Screenshot Tool)..."
        sudo dnf install -y shutter

        echo "Installing KTouch (Typing Tutor)..."
        sudo dnf install -y ktouch

        echo "Installing Shotwell (Photo Organizer)..."
        sudo dnf install -y shotwell
        ;;

    centos|redhat)
        echo "Updating package database for $OS..."
        sudo yum update -y

        echo "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        echo "Installing Baobab (Disk Usage Analyzer)..."
        sudo yum install -y baobab

        echo "Installing Shutter (Screenshot Tool)..."
        sudo yum install -y shutter

        echo "Installing KTouch (Typing Tutor)..."
        sudo yum install -y ktouch

        echo "Installing Shotwell (Photo Organizer)..."
        sudo yum install -y shotwell
        ;;

    opensuse)
        echo "Updating package database for $OS..."
        sudo zypper refresh

        echo "Installing Baobab (Disk Usage Analyzer)..."
        sudo zypper install -y baobab

        echo "Installing Shutter (Screenshot Tool)..."
        sudo zypper install -y shutter

        echo "Installing KTouch (Typing Tutor)..."
        sudo zypper install -y ktouch

        echo "Installing Shotwell (Photo Organizer)..."
        sudo zypper install -y shotwell
        ;;

    alpine)
        echo "Updating package database for $OS..."
        sudo apk update

        echo "Installing Baobab (Disk Usage Analyzer)..."
        sudo apk add baobab

        echo "Installing Shutter (Screenshot Tool)..."
        sudo apk add shutter

        echo "Installing KTouch (Typing Tutor)..."
        sudo apk add ktouch

        echo "Installing Shotwell (Photo Organizer)..."
        sudo apk add shotwell
        ;;

    macos)
        if command -v brew &> /dev/null; then
            echo "Homebrew is installed. Updating..."
            brew update

            echo "Installing Baobab (Disk Usage Analyzer)..."
            brew install baobab

            echo "Installing Shutter (Screenshot Tool)..."
            brew install shutter

            echo "Installing KTouch (Typing Tutor)..."
            brew install ktouch

            echo "Installing Shotwell (Photo Organizer)..."
            brew install shotwell
        else
            echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        echo "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            echo "Installing utilities via snap..."
            sudo snap install baobab shutter ktouch shotwell
        else
            echo "Snap is not installed. Please install Snap or use your package manager to install utilities."
            exit 1
        fi
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
echo "Verifying installation..."
for utility in baobab shutter ktouch shotwell; do
    if command -v $utility &> /dev/null; then
        echo "✅ $utility installed successfully."
    else
        echo "❌ $utility installation failed. Please check for errors."
    fi
done

echo "All installations completed successfully on $OS."
