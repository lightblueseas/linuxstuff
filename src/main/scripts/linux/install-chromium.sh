#!/usr/bin/env bash

# Chromium Installation Script for Multiple OS
# This script installs Chromium Browser and related packages based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Check if each package is already installed
check_installed() {
    if command -v $1 &> /dev/null; then
        info "$1 is already installed. Skipping installation."
        return 0
    else
        return 1
    fi
}

# Create an array for packages to install
to_install=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["chromium-browser"]="Open-source web browser."
    ["chromium-browser-l10n"]="Language packs for Chromium Browser."
    ["chromium-codecs-ffmpeg"]="Basic media codecs for Chromium."
    ["chromium-codecs-ffmpeg-extra"]="Additional media codecs for Chromium."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch|fedora|centos|redhat|opensuse|alpine)
        descriptions=(
            ["chromium"]="Open-source web browser."
            ["ffmpeg"]="Media codecs for Chromium."
        )
        ;;
    macos)
        descriptions=(
            ["chromium"]="Open-source web browser."
        )
        ;;
esac

# Check and add missing packages to the installation list
for package in "${!descriptions[@]}"; do
    if check_installed $package; then
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        to_install+=($package)
    fi
done

# Exit if all packages are already installed
if [[ ${#to_install[@]} -eq 0 ]]; then
    info "All Chromium packages are already installed. Exiting."
    exit 0
fi

info "Chromium Browser is not fully installed. Attempting to install missing components..."

# Install missing packages based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Detected Debian-based system. Updating package database..."
        sudo apt-get update -y
        for package in "${to_install[@]}"; do
            info "Installing $package (${descriptions[$package]}) on $OS..."
            sudo apt-get install -y $package
        done
        ;;

    manjaro|arch)
        info "Detected Arch-based system. Updating package database..."
        pamac update --force-refresh
        for package in "${to_install[@]}"; do
            info "Installing $package (${descriptions[$package]}) on $OS..."
            pamac install --no-confirm $package
        done
        ;;

    fedora|centos|redhat)
        info "Detected RPM-based system. Updating package database..."
        sudo dnf update -y || sudo yum update -y
        for package in "${to_install[@]}"; do
            info "Installing $package (${descriptions[$package]}) on $OS..."
            sudo dnf install -y $package || sudo yum install -y $package
        done
        ;;

    opensuse)
        info "Detected openSUSE system. Updating package database..."
        sudo zypper refresh
        for package in "${to_install[@]}"; do
            info "Installing $package (${descriptions[$package]}) on $OS..."
            sudo zypper install -y $package
        done
        ;;

    alpine)
        info "Detected Alpine Linux. Updating package database..."
        sudo apk update
        for package in "${to_install[@]}"; do
            info "Installing $package (${descriptions[$package]}) on $OS..."
            sudo apk add $package
        done
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Using Homebrew to install missing packages..."
            brew update
            for package in "${to_install[@]}"; do
                info "Installing $package..."
                brew install --cask $package
            done
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            for package in "${to_install[@]}"; do
                info "Installing $package via snap..."
                sudo snap install $package
            done
        else
            error "Snap is not installed. Please install Snap or use your package manager to install Chromium Browser."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying Chromium Browser installation..."
for package in "${to_install[@]}"; do
    if check_installed $package; then
        info "✅ $package installed successfully."
    else
        error "❌ $package installation failed. Please check for errors."
    fi
done

info "Chromium Browser installation completed successfully on $OS."
