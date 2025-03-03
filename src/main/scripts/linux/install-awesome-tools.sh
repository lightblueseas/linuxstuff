#!/usr/bin/env bash

# Utilities Installation Script for Multiple OS
# This script installs Baobab, Shutter, KTouch, and Shotwell based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Check if each utility is already installed
check_installed() {
    if command -v $1 &> /dev/null; then
        info "$1 is already installed. Skipping installation."
        return 0
    else
        return 1
    fi
}

# Create an array for utilities to install
to_install=()

# Descriptions for each utility
declare -A descriptions=(
    ["baobab"]="Disk Usage Analyzer for visualizing disk usage."
    ["shutter"]="Screenshot Tool for capturing and editing screenshots."
    ["ktouch"]="Typing Tutor for learning touch typing."
    ["shotwell"]="Photo Organizer for managing and editing photos."
)

# Check and add missing utilities to the installation list
for utility in "${!descriptions[@]}"; do
    if check_installed $utility; then
        continue
    else
        info "Preparing to install ${descriptions[$utility]}"
        to_install+=($utility)
    fi
done

if [[ ${#to_install[@]} -eq 0 ]]; then
    info "All utilities are already installed. Exiting."
    exit 0
fi

# Step 2: Install missing utilities based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y
        for utility in "${to_install[@]}"; do
            info "Installing $utility (${descriptions[$utility]})..."
            sudo apt-get install -y $utility
        done
        ;;

    manjaro|arch)
        info "Updating package database for $OS..."
        pamac update --force-refresh
        for utility in "${to_install[@]}"; do
            info "Installing $utility (${descriptions[$utility]})..."
            pamac install --no-confirm $utility
        done
        ;;

    fedora)
        info "Updating package database for $OS..."
        sudo dnf update -y
        for utility in "${to_install[@]}"; do
            info "Installing $utility (${descriptions[$utility]})..."
            sudo dnf install -y $utility
        done
        ;;

    centos|redhat)
        info "Updating package database for $OS..."
        sudo yum update -y
        sudo yum install -y epel-release
        for utility in "${to_install[@]}"; do
            info "Installing $utility (${descriptions[$utility]})..."
            sudo yum install -y $utility
        done
        ;;

    opensuse)
        info "Updating package database for $OS..."
        sudo zypper refresh
        for utility in "${to_install[@]}"; do
            info "Installing $utility (${descriptions[$utility]})..."
            sudo zypper install -y $utility
        done
        ;;

    alpine)
        info "Updating package database for $OS..."
        sudo apk update
        for utility in "${to_install[@]}"; do
            info "Installing $utility (${descriptions[$utility]})..."
            sudo apk add $utility
        done
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Homebrew is installed. Updating..."
            brew update
            for utility in "${to_install[@]}"; do
                info "Installing $utility (${descriptions[$utility]})..."
                brew install $utility
            done
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            for utility in "${to_install[@]}"; do
                info "Installing $utility via snap (${descriptions[$utility]})..."
                sudo snap install $utility
            done
        else
            error "Snap is not installed. Please install Snap or use your package manager to install utilities."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying installation..."
for utility in "${to_install[@]}"; do
    if command -v $utility &> /dev/null; then
        info "✅ $utility installed successfully."
    else
        error "❌ $utility installation failed. Please check for errors."
    fi
done

info "All installations completed successfully on $OS."
