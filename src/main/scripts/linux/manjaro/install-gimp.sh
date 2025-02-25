#!/usr/bin/env bash

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

# Check if running on Manjaro
if ! command -v pacman &> /dev/null; then
    error "This script is for Manjaro only. Exiting..."
    exit 1
fi

info "Detected Manjaro Linux."
info "Updating package list..."
sudo pacman -Sy --noconfirm

# Check if GIMP is installed
if command -v gimp &> /dev/null; then
    info "GIMP is already installed. Skipping installation."
else
    info "Installing GIMP and additional plugins..."

    # Install GIMP and available plugins
    sudo pacman -S --noconfirm \
        gimp \
        gimp-help-de \
        gimp-plugin-gmic \
        gutenprint
fi

info "GIMP installation complete! 🎉"
