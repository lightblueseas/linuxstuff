#!/usr/bin/env bash

# Audacious Installation Script for Multiple OS
# This script installs Audacious and its plugins based on the detected OS

# Colors for output
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# Function to print messages
info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# Path to detect_os.sh
DETECT_OS_SCRIPT="./detect_os.sh"

# Check if detect_os.sh is executable
if [[ ! -x "$DETECT_OS_SCRIPT" ]]; then
    warning "detect_os.sh is not executable. Attempting to fix permissions..."
    chmod +x "$DETECT_OS_SCRIPT"
    if [[ $? -ne 0 ]]; then
        error "Failed to add execute permissions to detect_os.sh. Please run: chmod +x $DETECT_OS_SCRIPT"
        exit 1
    else
        info "Permissions fixed for detect_os.sh."
    fi
fi

# Step 1: Detect OS using the external script
OS=$($DETECT_OS_SCRIPT)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    error "Could not detect the OS or unsupported OS detected."
    exit 1
fi

info "Detected OS: $OS"

# Check if Audacious is already installed
if command -v audacious &> /dev/null; then
    info "Audacious is already installed: $(audacious --version 2>/dev/null | head -n 1)"
    exit 0
fi

info "Audacious is not installed. Attempting to install it..."

# Step 2: Install Audacious based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y

        info "Installing Audacious on $OS..."
        sudo apt-get install -y audacious audacious-plugins
        ;;

    manjaro|arch)
        info "Updating package database for $OS..."
        pamac update --force-refresh

        info "Installing Audacious on $OS..."
        pamac install --no-confirm audacious audacious-plugins
        ;;

    fedora)
        info "Updating package database for $OS..."
        sudo dnf update -y

        info "Installing Audacious on $OS..."
        sudo dnf install -y audacious audacious-plugins
        ;;

    centos|redhat)
        info "Updating package database for $OS..."
        sudo yum update -y

        info "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        info "Installing Audacious on $OS..."
        sudo yum install -y audacious audacious-plugins
        ;;

    opensuse)
        info "Updating package database for $OS..."
        sudo zypper refresh

        info "Installing Audacious on $OS..."
        sudo zypper install -y audacious audacious-plugins
        ;;

    alpine)
        info "Updating package database for $OS..."
        sudo apk update

        info "Installing Audacious on $OS..."
        sudo apk add audacious audacious-plugins
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
