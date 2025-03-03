#!/usr/bin/env bash

# Git Installation Script for Multiple OS
# This script installs Git, Git Flow, and Curl based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package
declare -A descriptions=(
    ["curl"]="Command line tool for transferring data with URLs."
    ["git"]="Version control system to track changes in source code."
    ["git-flow"]="Extensions for Git to provide high-level repository operations."
)

# Check if each component is already installed
check_installed() {
    if command -v $1 &> /dev/null; then
        info "$1 is already installed. Skipping installation."
        return 0
    else
        return 1
    fi
}

# Check and add missing components to the installation list
for package in "${!descriptions[@]}"; do
    if check_installed $package; then
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=($package)
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All Git components are already installed. Exiting."
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
        info "Detected Arch-based system. Updating package database..."
        pamac update --force-refresh

        # Filter out already installed packages
        MISSING_PACKAGES=()
        for component in "${TO_INSTALL[@]}"; do
            if pacman -Qq "$component" &> /dev/null; then
                info "$component is already installed. Skipping installation."
            else
                MISSING_PACKAGES+=("$component")
            fi
        done

        # Exit if no packages are missing
        if [[ ${#MISSING_PACKAGES[@]} -eq 0 ]]; then
            info "All requested components are already installed. Exiting."
            exit 0
        fi

        # Install missing packages
        for component in "${MISSING_PACKAGES[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            pamac install --no-confirm "$component"
        done
        ;;

    fedora)
        info "Detected Fedora system. Updating package database..."
        sudo dnf update -y
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            sudo dnf install -y "$component"
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

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
for component in "${TO_INSTALL[@]}"; do
    if command -v "$component" &> /dev/null; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
    fi
done

# Check git config
if ! git config --get user.name >/dev/null 2>&1; then
    warning "Git user.name is not set. Please configure it."
    echo "Example: git config --global user.name 'Your Name'"
fi

if ! git config --get user.email >/dev/null 2>&1; then
    warning "Git user.email is not set. Please configure it."
    echo "Example: git config --global user.email 'your.email@example.com'"
fi

info "Git installation completed successfully."
