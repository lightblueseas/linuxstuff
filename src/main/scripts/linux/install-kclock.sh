#!/usr/bin/env bash

# KClock Installation Script for Multiple OS
# This script installs KClock based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Check if KClock is already installed
if command -v kclock &> /dev/null; then
    info "KClock is already installed: $(kclock --version 2>/dev/null || echo 'version information not available')"
    exit 0
fi

install_wecker() {
    case "$OS" in
        arch|manjaro)
            info "Installing KClock on Manjaro/Arch..."
            info "KClock: A simple application for managing alarms, timers, and world clocks in KDE."
            sudo pacman -S --noconfirm kclock
            ;;
        ubuntu|debian|raspbian|wsl)
            info "Installing KClock on Ubuntu/Debian/Raspbian/WSL..."
            info "KClock: A simple and elegant clock application for KDE desktop."
            sudo apt-get update -y
            sudo apt-get install -y kclock || {
                warning "KClock might not be available in default repositories. Trying KDE backports..."
                sudo add-apt-repository ppa:kubuntu-ppa/backports -y
                sudo apt-get update -y
                sudo apt-get install -y kclock || error "KClock installation failed."
            }
            ;;
        fedora)
            info "Installing KClock on Fedora..."
            info "KClock: Provides alarms, world clocks, and a stopwatch for KDE."
            sudo dnf install -y kclock
            ;;
        centos|redhat)
            info "Installing KClock on CentOS/Red Hat..."
            info "KClock: Manage time with alarms, world clocks, and timers."
            sudo yum install -y epel-release
            sudo yum install -y kclock || error "KClock might not be available on CentOS/Red Hat."
            ;;
        opensuse)
            info "Installing KClock on openSUSE..."
            info "KClock: Manage time with alarms, world clocks, and timers."
            sudo zypper install -y kclock
            ;;
        alpine)
            info "Detected Alpine Linux."
            info "Installing KClock (if available in the repositories)..."
            sudo apk update
            sudo apk add kclock || warning "KClock may not be available on Alpine Linux."
            ;;
        macos)
            if command -v brew &> /dev/null; then
                info "Installing KClock on macOS via Homebrew..."
                info "KClock: Not natively available on macOS, attempting to install a similar package."
                brew install --cask clocker || warning "KClock is not available on macOS. Installed Clocker instead."
            else
                error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
                exit 1
            fi
            ;;
        linux)
            warning "Detected a generic Linux distribution. Attempting Flatpak installation..."
            if command -v flatpak >/dev/null 2>&1; then
                info "Installing KClock via Flatpak..."
                flatpak install -y flathub org.kde.kclock || error "KClock installation failed via Flatpak."
            else
                error "Flatpak is not installed. Please install manually."
                exit 1
            fi
            ;;
        *)
            error "Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

install_wecker

# Verify installation
info "Verifying KClock installation..."
if command -v kclock &> /dev/null; then
    info "✅ KClock installed successfully."
else
    error "❌ KClock installation failed. Please try installing it manually."
    exit 1
fi

info "Installation complete. You can now start KClock."
