#!/usr/bin/env bash

# SDKMAN! and Java Installation Script for Multiple OS with Password Caching
# This script installs SDKMAN! and a specified Java version based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Prompt for sudo password once and store it securely
read -s -p "Enter your password for sudo: " SUDO_PASSWORD
echo  # Move to the next line after password input

# Function to execute sudo commands with cached password
sudo_exec() {
    echo "$SUDO_PASSWORD" | sudo -S "$@"
}

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package
declare -A descriptions=(
    ["curl"]="Command line tool for transferring data with URLs."
    ["zip"]="Utility for creating compressed files in ZIP format."
    ["unzip"]="Utility for extracting compressed ZIP files."
    ["sdkman"]="SDKMAN! for managing parallel versions of multiple SDKs."
)

# Function to check if a command exists
check_installed() {
    if command -v "$1" &> /dev/null; then
        info "$1 is already installed. Skipping installation."
        return 0
    else
        return 1
    fi
}

# Function to check if a package is installed on Arch-based systems using pacman
check_pacman_installed() {
    if pacman -Qq "$1" &> /dev/null; then
        info "$1 is already installed. Skipping installation."
        return 0
    else
        return 1
    fi
}

# Check if SDKMAN! is installed by verifying the existence of sdk command or the SDKMAN directory
check_sdkman_installed() {
    if command -v sdk &> /dev/null || [[ -d "$HOME/.sdkman" ]]; then
        info "SDKMAN! is already installed. Skipping installation."
        return 0
    else
        return 1
    fi
}

# Check and add missing components to the installation list
for package in "curl" "zip" "unzip"; do
    if check_installed "$package"; then
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All dependencies are already installed."
else
    info "Components to install: ${TO_INSTALL[*]}"
fi

# Step 2: Install missing components based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Detected Debian-based system."
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Updating package database..."
            sudo_exec apt-get update -y
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on $OS..."
                sudo_exec apt-get install -y "$component"
            done
        fi
        ;;

    manjaro|arch)
        info "Detected Arch-based system."
        MISSING_PACKAGES=()
        # Check for missing packages
        for component in "${TO_INSTALL[@]}"; do
            if check_pacman_installed "$component"; then
                continue
            else
                MISSING_PACKAGES+=("$component")
            fi
        done

        if [[ ${#MISSING_PACKAGES[@]} -eq 0 ]]; then
            info "All required packages are already installed. Skipping update."
        else
            info "Updating package database for missing packages..."
            echo "$SUDO_PASSWORD" | pamac update --force-refresh --no-confirm
            for component in "${MISSING_PACKAGES[@]}"; do
                info "Installing $component (${descriptions[$component]}) on $OS..."
                echo "$SUDO_PASSWORD" | pamac install --no-confirm "$component"
            done
        fi
        ;;

    fedora|centos|redhat)
        info "Detected RPM-based system."
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Updating package database..."
            sudo_exec dnf update -y || sudo_exec yum update -y
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on $OS..."
                sudo_exec dnf install -y "$component" || sudo_exec yum install -y "$component"
            done
        fi
        ;;

    opensuse)
        info "Detected openSUSE system."
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Updating package database..."
            sudo_exec zypper refresh
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on openSUSE..."
                sudo_exec zypper install -y "$component"
            done
        fi
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
esac

# Install SDKMAN! if not already installed
if check_sdkman_installed; then
    info "SDKMAN! is already installed."
else
    info "Installing SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    if sdk version; then
        info "SDKMAN! installed successfully."
    else
        error "SDKMAN! installation failed."
        exit 1
    fi
fi

# Install a specific Java version if specified
read -p "Enter Java version to install (or press Enter to skip): " JAVA_VERSION
if [[ -n "$JAVA_VERSION" ]]; then
    sdk install java "$JAVA_VERSION"
else
    info "Skipping Java installation."
fi

# Unset password variable to clear it from memory
unset SUDO_PASSWORD

info "SDKMAN! and Java installation process completed successfully on $OS."
