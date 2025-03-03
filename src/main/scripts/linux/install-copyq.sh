#!/bin/bash

# CopyQ Installation Script for Multiple OS
# This script installs CopyQ based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Check if CopyQ is already installed
if command -v copyq &> /dev/null; then
    info "CopyQ is already installed: $(copyq --version 2>/dev/null | head -n 1)"
    exit 0
fi

info "CopyQ is not installed. Preparing to install it..."

# Create an array for components to install
TO_INSTALL=("copyq")

# Step 2: Install CopyQ based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Detected Debian-based system. Updating package database..."
        sudo apt-get update -y
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component on $OS..."
            sudo apt-get install -y "$component"
        done
        ;;

    manjaro|arch)
        info "Detected Arch-based system. Updating package database..."
        pamac update --force-refresh
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component on $OS..."
            pamac install --no-confirm "$component"
        done
        ;;

    fedora)
        info "Detected Fedora system. Updating package database..."
        sudo dnf update -y
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component on $OS..."
            sudo dnf install -y "$component"
        done
        ;;

    centos|redhat)
        info "Detected CentOS/Red Hat system. Updating package database..."
        sudo yum update -y
        sudo yum install -y epel-release
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component on $OS..."
            sudo yum install -y "$component"
        done
        ;;

    opensuse)
        info "Detected openSUSE system. Updating package database..."
        sudo zypper refresh
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component on $OS..."
            sudo zypper install -y "$component"
        done
        ;;

    alpine)
        info "Detected Alpine Linux. Updating package database..."
        sudo apk update
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component on $OS..."
            sudo apk add "$component"
        done
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Homebrew is installed. Updating..."
            brew update
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component on macOS..."
                brew install "$component"
            done
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component via snap..."
                sudo snap install "$component"
            done
        else
            error "Snap is not installed. Please install Snap or use your package manager to install CopyQ."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying CopyQ installation..."
for component in "${TO_INSTALL[@]}"; do
    if command -v "$component" &> /dev/null; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

info "CopyQ installation completed successfully on $OS."
