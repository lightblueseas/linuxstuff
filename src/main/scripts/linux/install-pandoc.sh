#!/usr/bin/env bash

# Pandoc Installation Script for Multiple OS
# This script installs Pandoc based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package
declare -A descriptions=(
    ["pandoc"]="Universal document converter that can convert files between various formats."
)

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Pandoc is already installed
if command_exists pandoc; then
    info "Pandoc is already installed: $(pandoc --version | head -n 1)"
    exit 0
else
    info "Pandoc is not installed. Preparing to install it..."
    TO_INSTALL+=("pandoc")
fi

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All required components are already installed. Exiting."
    exit 0
fi

# Run sudo only if there are packages to install
info "Components to install: ${TO_INSTALL[*]}"

# Step 2: Install missing components based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Detected Debian-based system. Updating package database..."
        sudo apt-get update -y
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            sudo apt-get install -y "$component"
        done
        ;;
    manjaro|arch)
        info "Detected Arch-based system. Checking and installing missing packages..."
        pamac update --force-refresh
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            pamac install --no-confirm "$component"
        done
        ;;
    fedora|centos|redhat)
        info "Detected RPM-based system. Updating package database..."
        sudo dnf update -y || sudo yum update -y
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            sudo dnf install -y "$component" || sudo yum install -y "$component"
        done
        ;;
    opensuse)
        info "Detected openSUSE system. Updating package database..."
        sudo zypper refresh
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on openSUSE..."
            sudo zypper install -y "$component"
        done
        ;;
    macos)
        if command -v brew &> /dev/null; then
            info "Homebrew is installed. Updating..."
            brew update
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on macOS..."
                brew install "$component"
            done
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;
    linux)
        if command -v snap &> /dev/null; then
            info "Detected a generic Linux distribution. Attempting to install via snap..."
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component via snap (${descriptions[$component]})..."
                sudo snap install "$component"
            done
        else
            error "Snap is not installed. Please install Snap or use your package manager to install the components."
            exit 1
        fi
        ;;
    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying Pandoc installation..."
for component in "${TO_INSTALL[@]}"; do
    if command_exists "$component"; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

info "Pandoc installation completed successfully on $OS."
