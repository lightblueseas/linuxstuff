#!/usr/bin/env bash

# GNOME Sushi Installation Script for Multiple OS
# This script installs GNOME Sushi for quick file previews in Nautilus based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

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
            info "Detected Arch-based system. Checking if gnome-sushi is available in official repositories..."

            # Use pacman to check if gnome-sushi exists to avoid password prompts
            if pacman -Ss gnome-sushi | grep -q "gnome-sushi"; then
                info "gnome-sushi found in official repositories. Preparing to install..."
                pamac update --force-refresh

                info "Installing GNOME Sushi from official repositories..."
                pamac install --no-confirm gnome-sushi
            else
                warning "gnome-sushi not found in official repositories. Trying AUR..."

                # Check AUR without sudo to avoid password prompt
                if yay -Ss gnome-sushi | grep -q "gnome-sushi"; then
                    info "gnome-sushi found in AUR. Preparing to install..."
                    yay -S --noconfirm gnome-sushi
                else
                    warning "gnome-sushi not found in AUR either. Skipping installation."
                    exit 0
                fi
            fi
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
