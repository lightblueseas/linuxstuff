#!/usr/bin/env bash

# GNOME Sushi Installation Script for Multiple OS
# This script installs GNOME Sushi for quick file previews in Nautilus based on the detected OS

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

# Check if GNOME Sushi is already installed
if command -v gnome-sushi &> /dev/null; then
    info "GNOME Sushi is already installed."
    exit 0
fi

install_sushi() {
    case "$OS" in
        ubuntu|debian|raspbian|wsl)
            info "Updating package database for $OS..."
            sudo apt-get update -y

            info "Installing GNOME Sushi (Quick file preview extension for Nautilus)..."
            sudo apt-get install -y gnome-sushi
            ;;

        manjaro|arch)
            info "Updating package database for $OS..."
            pamac update --force-refresh

            info "Installing GNOME Sushi (Quick file preview extension for Nautilus)..."
            pamac install --no-confirm gnome-sushi
            ;;

        fedora)
            info "Updating package database for Fedora..."
            sudo dnf update -y

            info "Installing GNOME Sushi (Quick file preview extension for Nautilus)..."
            sudo dnf install -y gnome-sushi
            ;;

        centos|redhat)
            info "Detected CentOS/Red Hat system."
            sudo yum update -y
            sudo yum install -y epel-release

            info "GNOME Sushi may not be available in official repos. Installing Sushi (alternative package)..."
            sudo yum install -y sushi || warning "Sushi may not provide the same functionality as GNOME Sushi."
            ;;

        opensuse)
            info "Detected openSUSE system."
            sudo zypper refresh

            info "Installing GNOME Sushi (Quick file preview extension for Nautilus)..."
            sudo zypper install -y gnome-sushi
            ;;

        alpine)
            info "Detected Alpine Linux."
            info "GNOME Sushi may not be available on Alpine. Attempting installation..."
            sudo apk update
            sudo apk add gnome-sushi || warning "GNOME Sushi may not be available on Alpine Linux."
            ;;

        macos)
            if command -v brew &> /dev/null; then
                info "Installing Sushi (alternative package) on macOS via Homebrew..."
                brew install sushi || warning "GNOME Sushi is not available on macOS. Installed Sushi instead."
            else
                error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
                exit 1
            fi
            ;;

        linux)
            warning "Detected a generic Linux distribution. Attempting Snap installation..."
            if command -v snap >/dev/null 2>&1; then
                info "Installing GNOME Sushi via Snap..."
                sudo snap install gnome-sushi
            else
                error "Snap is not installed. Please install manually."
                exit 1
            fi
            ;;

        *)
            error "Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

install_sushi

# Verify installation
info "Verifying GNOME Sushi installation..."
if command -v gnome-sushi &> /dev/null; then
    info "✅ GNOME Sushi installed successfully."
else
    error "❌ GNOME Sushi installation failed. Please try installing it manually."
    exit 1
fi

info "Installation complete! You can now preview files in Nautilus by pressing the Space key."
