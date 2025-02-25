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

# Detect the package manager
if command -v apt &> /dev/null; then
    PM="apt"
    OS="Ubuntu/Debian"
elif command -v pacman &> /dev/null; then
    PM="pacman"
    OS="Manjaro/Arch"
else
    error "Unsupported OS. This script supports Ubuntu/Debian and Manjaro/Arch."
    exit 1
fi

info "Detected OS: $OS"
info "Updating package list..."

# Update package list based on the package manager
if [[ "$PM" == "apt" ]]; then
    sudo apt update -y
elif [[ "$PM" == "pacman" ]]; then
    sudo pacman -Sy --noconfirm
fi

# Check if GIMP is already installed
if command -v gimp &> /dev/null; then
    info "GIMP is already installed. Skipping installation."
else
    info "Installing GIMP and additional plugins..."

    if [[ "$PM" == "apt" ]]; then
        sudo apt install -y \
            gimp \
            gimp-help-de \
            language-pack-gnome-de \
            gimp-dcraw \
            gimp-ufraw \
            gimp-gap \
            gimp-gutenprint \
            gimp-plugin-registry \
            gimp-resynthesizer \
            gimp-python \
            gmic
    elif [[ "$PM" == "pacman" ]]; then
        sudo pacman -S --noconfirm \
            gimp \
            gimp-help-de \
            gimp-plugin-gmic \
            gutenprint
    fi
fi

info "GIMP installation complete!"
