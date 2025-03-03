#!/usr/bin/env bash

# Python3 and pip Installation Script for Multiple OS
# This script installs Python3 and pip based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["python"]="Python 3 interpreter."
    ["python-pip"]="pip package manager for Python 3."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch)
        descriptions=(
            ["python"]="Python 3 interpreter."
            ["python-pip"]="pip package manager for Python 3."
        )
        ;;
    fedora|centos|redhat|opensuse)
        descriptions=(
            ["python3"]="Python 3 interpreter."
            ["python3-pip"]="pip package manager for Python 3."
        )
        ;;
    macos)
        descriptions=(
            ["python3"]="Python 3 interpreter."
            ["pip3"]="pip package manager for Python 3."
        )
        ;;
esac

# Enhanced function to check if a package is installed
check_installed() {
    case "$OS" in
        manjaro|arch)
            # Check if package is installed using pacman
            if pacman -Qi "$1" &>/dev/null; then
                info "$1 is already installed. Skipping installation."
                return 0
            else
                return 1
            fi
            ;;
        ubuntu|debian|raspbian|wsl)
            dpkg -s "$1" &>/dev/null
            ;;
        fedora|centos|redhat|opensuse)
            rpm -q "$1" &>/dev/null
            ;;
        macos)
            brew list "$1" &>/dev/null
            ;;
        linux)
            snap list "$1" &>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

# Check and add missing components to the installation list
for package in "${!descriptions[@]}"; do
    if check_installed "$package"; then
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All Python3 and pip components are already installed. Exiting."
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
esac

# Step 3: Verify installation
info "Verifying Python3 and pip installation..."
if command -v python3 &> /dev/null && command -v pip &> /dev/null; then
    info "✅ Python3 and pip installed successfully."
else
    error "❌ Installation failed. Please check for errors."
    exit 1
fi

info "Python3 and pip installation completed successfully on $OS."
