#!/usr/bin/env bash

# G'MIC Installation Script for Multiple OS
# This script installs GIMP and the G'MIC plugin based on the detected OS

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

# Step 1: Detect OS using the external script
OS=$(./detect_os.sh)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    error "Could not detect the OS or unsupported OS detected."
    exit 1
fi

info "Detected OS: $OS"

# Check if GIMP is already installed
if command -v gimp &> /dev/null; then
    info "GIMP is already installed: $(gimp --version)"
else
    info "GIMP is not installed. Attempting to install it..."
fi

# Step 2: Install GIMP and G'MIC based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y && sudo apt-get upgrade -y

        info "Installing GIMP (GNU Image Manipulation Program)..."
        sudo apt-get install -y gimp

        info "Installing G'MIC (GREYC's Magic for Image Computing) and G'MIC Plugin for GIMP..."
        sudo apt-get install -y gmic gimp-gmic
        ;;

    manjaro|arch)
        info "Updating package database for $OS..."
        pamac update --force-refresh

        info "Installing GIMP (GNU Image Manipulation Program)..."
        pamac install --no-confirm gimp

        info "Installing G'MIC Plugin for GIMP..."
        pamac install --no-confirm gmic gimp-plugin-gmic
        ;;

    fedora)
        info "Updating package database for Fedora..."
        sudo dnf update -y

        info "Installing GIMP and G'MIC..."
        sudo dnf install -y gimp gmic gimp-gmic
        ;;

    centos|redhat)
        info "Detected CentOS/Red Hat system."
        sudo yum update -y
        sudo yum install -y epel-release

        info "Installing GIMP and G'MIC..."
        sudo yum install -y gimp gmic
        ;;

    opensuse)
        info "Detected openSUSE system."
        sudo zypper refresh

        info "Installing GIMP and G'MIC..."
        sudo zypper install -y gimp gmic
        ;;

    alpine)
        info "Detected Alpine Linux."
        sudo apk update

        info "Installing GIMP (without G'MIC due to limited support on Alpine)..."
        sudo apk add gimp
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Using Homebrew to install GIMP..."
            brew install --cask gimp

            info "Installing G'MIC via Homebrew..."
            brew install gmic
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

            info "Installing G'MIC Plugin for GIMP via snap..."
            sudo snap install gmic
        else
            error "Snap is not installed. Please install Snap or use your package manager to install GIMP and G'MIC."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying G'MIC installation..."
if command -v gmic &> /dev/null && [ -f /usr/lib/gimp/2.0/plug-ins/gmic_gimp_qt ]; then
    info "✅ G'MIC and G'MIC Plugin for GIMP installed successfully."
else
    error "❌ Installation failed. Please check the logs for details."
    exit 1
fi

# Step 4: Display G'MIC version
gmic --version

info "Installation complete! You can now use G'MIC in GIMP under Filters → G’MIC-Qt."
