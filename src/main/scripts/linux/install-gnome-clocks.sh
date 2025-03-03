#!/usr/bin/env bash

# GNOME Clocks Installation Script for Multiple OS
# This script installs GNOME Clocks based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Check if GNOME Clocks is already installed
if command -v gnome-clocks &> /dev/null; then
    info "GNOME Clocks is already installed: $(gnome-clocks --version 2>/dev/null || echo 'version information not available')"
    exit 0
fi

install_wecker() {
    case "$OS" in
        arch|manjaro)
            info "Installing GNOME Clocks on Manjaro/Arch..."
            info "GNOME Clocks: A simple application for managing alarms, timers, and world clocks."
            sudo pacman -S --noconfirm gnome-clocks
            ;;
        ubuntu|debian|raspbian|wsl)
            info "Installing GNOME Clocks on Ubuntu/Debian/Raspbian/WSL..."
            info "GNOME Clocks: A simple and elegant clock application for GNOME desktop."
            sudo apt-get update -y
            sudo apt-get install -y gnome-clocks
            ;;
        fedora)
            info "Installing GNOME Clocks on Fedora..."
            info "GNOME Clocks: Provides alarms, world clocks, and a stopwatch."
            sudo dnf install -y gnome-clocks
            ;;
        centos|redhat)
            info "Installing GNOME Clocks on CentOS/Red Hat..."
            info "GNOME Clocks: Manage time with alarms, world clocks, and timers."
            sudo yum install -y epel-release
            sudo yum install -y gnome-clocks
            ;;
        opensuse)
            info "Installing GNOME Clocks on openSUSE..."
            info "GNOME Clocks: Manage time with alarms, world clocks, and timers."
            sudo zypper install -y gnome-clocks
            ;;
        alpine)
            info "Detected Alpine Linux."
            info "Installing GNOME Clocks (if available in the repositories)..."
            sudo apk update
            sudo apk add gnome-clocks || warning "GNOME Clocks may not be available on Alpine Linux."
            ;;
        macos)
            if command -v brew &> /dev/null; then
                info "Installing GNOME Clocks on macOS via Homebrew..."
                info "GNOME Clocks: Not natively available on macOS, attempting to install a similar package."
                brew install --cask clocker || warning "GNOME Clocks is not available on macOS. Installed Clocker instead."
            else
                error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
                exit 1
            fi
            ;;
        linux)
            warning "Detected a generic Linux distribution. Attempting Snap installation..."
            if command -v snap >/dev/null 2>&1; then
                info "Installing GNOME Clocks via Snap..."
                sudo snap install gnome-clocks
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

install_wecker

# Verify installation
info "Verifying GNOME Clocks installation..."
if command -v gnome-clocks &> /dev/null; then
    info "✅ GNOME Clocks installed successfully."
else
    error "❌ GNOME Clocks installation failed. Please try installing it manually."
    exit 1
fi

info "Installation complete. You can now start GNOME Clocks."
