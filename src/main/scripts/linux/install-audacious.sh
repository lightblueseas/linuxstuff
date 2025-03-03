#!/usr/bin/env bash

# Audacious Installation Script for Multiple OS
# This script installs Audacious and its plugins based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Check if Audacious is already installed
if command -v audacious &> /dev/null; then
    info "Audacious is already installed: $(audacious --version 2>/dev/null | head -n 1)"
else
    info "Audacious is not installed. Attempting to install it..."
    TO_INSTALL=("audacious")
fi

# Check if Audacious plugins are already installed
if command -v audacious &> /dev/null && audacious --version | grep -qi "plugins"; then
    info "Audacious plugins are already installed."
else
    info "Audacious plugins are not installed. Attempting to install them..."
    TO_INSTALL+=("audacious-plugins")
fi

# If nothing to install, exit
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All components are already installed. Exiting."
    exit 0
fi

# Step 2: Install Audacious and plugins based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y

        info "Installing Audacious and plugins on $OS..."
        sudo apt-get install -y "${TO_INSTALL[@]}"
        ;;

    manjaro|arch)
        info "Updating package database for $OS..."
        pamac update --force-refresh

        info "Installing Audacious and plugins on $OS..."
        pamac install --no-confirm "${TO_INSTALL[@]}"
        ;;

    fedora)
        info "Updating package database for $OS..."
        sudo dnf update -y

        info "Installing Audacious and plugins on $OS..."
        sudo dnf install -y "${TO_INSTALL[@]}"
        ;;

    centos|redhat)
        info "Updating package database for $OS..."
        sudo yum update -y

        info "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        info "Installing Audacious and plugins on $OS..."
        sudo yum install -y "${TO_INSTALL[@]}"
        ;;

    opensuse)
        info "Updating package database for $OS..."
        sudo zypper refresh

        info "Installing Audacious and plugins on $OS..."
        sudo zypper install -y "${TO_INSTALL[@]}"
        ;;

    alpine)
        info "Updating package database for $OS..."
        sudo apk update

        info "Installing Audacious and plugins on $OS..."
        sudo apk add "${TO_INSTALL[@]}"
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Homebrew is installed. Updating..."
            brew update

            info "Installing Audacious on macOS..."
            brew install audacious
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            info "Installing Audacious via snap..."
            sudo snap install audacious
        else
            error "Snap is not installed. Please install Snap or use your package manager to install Audacious."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying Audacious installation..."
if command -v audacious &> /dev/null; then
    info "✅ Audacious installed successfully."
else
    error "❌ Audacious installation failed. Please check for errors."
    exit 1
fi

info "Audacious installation completed successfully on $OS."
