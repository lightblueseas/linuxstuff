#!/usr/bin/env bash

# ClamAV Installation Script for Multiple OS
# This script installs ClamAV based on the detected OS

# Step 1: Detect OS using the external script
OS=$(./detect_os.sh)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    echo "Could not detect the OS or unsupported OS detected."
    exit 1
fi

echo "Detected OS: $OS"

# Step 2: Install ClamAV based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        echo "Updating package database for $OS..."
        sudo apt-get update -y

        echo "Installing ClamAV on $OS..."
        sudo apt-get install -y clamav clamav-freshclam clamav-docs clamav-daemon clamtk clamtk-nautilus
        ;;

    manjaro|arch)
        echo "Updating package database for $OS..."
        pamac update --force-refresh

        echo "Installing ClamAV on $OS..."
        pamac install --no-confirm clamav clamtk
        ;;

    fedora)
        echo "Updating package database for $OS..."
        sudo dnf update -y

        echo "Installing ClamAV on $OS..."
        sudo dnf install -y clamav clamtk
        ;;

    centos|redhat)
        echo "Updating package database for $OS..."
        sudo yum update -y

        echo "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        echo "Installing ClamAV on $OS..."
        sudo yum install -y clamav clamtk
        ;;

    opensuse)
        echo "Updating package database for $OS..."
        sudo zypper refresh

        echo "Installing ClamAV on $OS..."
        sudo zypper install -y clamav clamtk
        ;;

    alpine)
        echo "Updating package database for $OS..."
        sudo apk update

        echo "Installing ClamAV on $OS..."
        sudo apk add clamav clamtk
        ;;

    macos)
        if command -v brew &> /dev/null; then
            echo "Homebrew is installed. Updating..."
            brew update

            echo "Installing ClamAV on macOS..."
            brew install clamav
        else
            echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        echo "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            echo "Installing ClamAV via snap..."
            sudo snap install clamav
        else
            echo "Snap is not installed. Please install Snap or use your package manager to install ClamAV."
            exit 1
        fi
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Enable and start ClamAV daemon if applicable
if [[ "$OS" != "macos" && "$OS" != "linux" ]]; then
    echo "Enabling and starting ClamAV daemon..."
    sudo systemctl enable clamav-daemon
    sudo systemctl start clamav-daemon

    echo "Checking ClamAV daemon status..."
    sudo systemctl status clamav-daemon

    echo "Stopping ClamAV daemon before updating database..."
    sudo systemctl stop clamav-daemon

    echo "Manually updating virus database..."
    sudo freshclam

    echo "Restarting ClamAV daemon..."
    sudo systemctl start clamav-daemon
fi

# Step 4: Verify installation
echo "Verifying ClamAV installation..."
if command -v clamscan &> /dev/null; then
    echo "✅ ClamAV installed successfully."
else
    echo "❌ ClamAV installation failed. Please check for errors."
    exit 1
fi

echo "ClamAV installation and setup completed successfully on $OS."
