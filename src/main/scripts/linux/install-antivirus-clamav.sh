#!/usr/bin/env bash

# ClamAV Installation Script for Multiple OS
# This script installs ClamAV based on the detected OS


# Source the common initialization script
source ./init_scripts.sh

# Check if ClamAV is already installed
if command -v clamscan &> /dev/null; then
    info "ClamAV is already installed: $(clamscan --version 2>/dev/null | head -n 1)"
    exit 0
fi

info "ClamAV is not installed. Attempting to install it..."

# Step 2: Install ClamAV based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y

        info "Installing ClamAV on $OS..."
        sudo apt-get install -y clamav clamav-freshclam clamav-docs clamav-daemon clamtk clamtk-nautilus
        ;;

    manjaro|arch)
        info "Updating package database for $OS..."
        pamac update --force-refresh

        info "Installing ClamAV on $OS..."
        pamac install --no-confirm clamav clamtk
        ;;

    fedora)
        info "Updating package database for $OS..."
        sudo dnf update -y

        info "Installing ClamAV on $OS..."
        sudo dnf install -y clamav clamtk
        ;;

    centos|redhat)
        info "Updating package database for $OS..."
        sudo yum update -y

        info "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        info "Installing ClamAV on $OS..."
        sudo yum install -y clamav clamtk
        ;;

    opensuse)
        info "Updating package database for $OS..."
        sudo zypper refresh

        info "Installing ClamAV on $OS..."
        sudo zypper install -y clamav clamtk
        ;;

    alpine)
        info "Updating package database for $OS..."
        sudo apk update

        info "Installing ClamAV on $OS..."
        sudo apk add clamav clamtk
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Homebrew is installed. Updating..."
            brew update

            info "Installing ClamAV on macOS..."
            brew install clamav
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            info "Installing ClamAV via snap..."
            sudo snap install clamav
        else
            error "Snap is not installed. Please install Snap or use your package manager to install ClamAV."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Enable and start ClamAV daemon if applicable
if [[ "$OS" != "macos" && "$OS" != "linux" ]]; then
    info "Enabling and starting ClamAV daemon..."
    sudo systemctl enable clamav-daemon
    sudo systemctl start clamav-daemon

    info "Checking ClamAV daemon status..."
    sudo systemctl status clamav-daemon

    info "Stopping ClamAV daemon before updating database..."
    sudo systemctl stop clamav-daemon

    info "Manually updating virus database..."
    sudo freshclam

    info "Restarting ClamAV daemon..."
    sudo systemctl start clamav-daemon
fi

# Step 4: Verify installation
info "Verifying ClamAV installation..."
if command -v clamscan &> /dev/null; then
    info "✅ ClamAV installed successfully."
else
    error "❌ ClamAV installation failed. Please check for errors."
    exit 1
fi

info "ClamAV installation and setup completed successfully on $OS."
