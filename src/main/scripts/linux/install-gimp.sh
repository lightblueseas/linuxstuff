#!/usr/bin/env bash

# GIMP Installation Script for Multiple OS
# This script installs GIMP and related plugins based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Check if GIMP is already installed
if command -v gimp &> /dev/null; then
    info "GIMP is already installed: $(gimp --version)"
    exit 0
fi

info "GIMP is not installed. Attempting to install it..."

# Step 2: Install GIMP based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y

        info "Installing GIMP (Image Manipulation Program)..."
        sudo apt-get install -y gimp

        info "Installing GIMP Help (German)..."
        sudo apt-get install -y gimp-help-de

        info "Installing GNOME language pack (German)..."
        sudo apt-get install -y language-pack-gnome-de

        info "Installing GIMP Plugins (dcraw, ufraw, gap, gutenprint, registry, resynthesizer, python support, G'MIC)..."
        sudo apt-get install -y \
            gimp-dcraw \
            gimp-ufraw \
            gimp-gap \
            gimp-gutenprint \
            gimp-plugin-registry \
            gimp-resynthesizer \
            gimp-python \
            gmic
        ;;

    manjaro|arch)
        info "Updating package database for $OS..."
        pamac update --force-refresh

        info "Installing GIMP (Image Manipulation Program)..."
        pamac install --no-confirm gimp

        info "Installing GIMP Help (German)..."
        pamac install --no-confirm gimp-help-de

        info "Installing G'MIC Plugin for GIMP..."
        pamac install --no-confirm gimp-plugin-gmic

        info "Installing Gutenprint (Printer drivers for GIMP)..."
        pamac install --no-confirm gutenprint
        ;;

    fedora)
        info "Updating package database for Fedora..."
        sudo dnf update -y

        info "Installing GIMP and plugins..."
        sudo dnf install -y gimp gimp-help gmic gutenprint
        ;;

    centos|redhat)
        info "Detected CentOS/Red Hat system."
        sudo yum update -y
        sudo yum install -y epel-release

        info "Installing GIMP and plugins..."
        sudo yum install -y gimp gimp-help gmic gutenprint
        ;;

    opensuse)
        info "Detected openSUSE system."
        sudo zypper refresh

        info "Installing GIMP and plugins..."
        sudo zypper install -y gimp gimp-help gmic gutenprint
        ;;

    alpine)
        info "Detected Alpine Linux."
        sudo apk update

        info "Installing GIMP (without plugins due to limited support on Alpine)..."
        sudo apk add gimp
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Using Homebrew to install GIMP..."
            brew install --cask gimp
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            info "Installing GIMP via snap..."
            sudo snap install gimp
        else
            error "Snap is not installed. Please install Snap or use your package manager to install GIMP."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying GIMP installation..."
if command -v gimp &> /dev/null; then
    info "✅ GIMP successfully installed: $(gimp --version)"
else
    error "❌ GIMP installation failed. Please try installing it manually."
    exit 1
fi

info "GIMP installation completed successfully on $OS."
