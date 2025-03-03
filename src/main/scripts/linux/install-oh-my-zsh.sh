#!/usr/bin/env bash

# Oh-My-Zsh Installation Script for Multiple OS
# This script installs Zsh, curl, wget, and Oh-My-Zsh based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["zsh"]="Zsh shell for enhanced terminal experience."
    ["curl"]="Command-line tool for transferring data with URLs."
    ["wget"]="Command-line utility for downloading files from the web."
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
    if check_installed "$package"; then
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All required components are already installed. Proceeding to Oh-My-Zsh installation."
else
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
fi

# Install Oh-My-Zsh if not already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    info "Oh-My-Zsh is already installed at $HOME/.oh-my-zsh. Skipping installation."
else
    info "Installing Oh-My-Zsh..."
    if command -v curl &> /dev/null; then
        info "Using curl to install Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    elif command -v wget &> /dev/null; then
        info "curl not found. Using wget to install Oh-My-Zsh..."
        sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    else
        error "Neither curl nor wget is available. Installation cannot proceed."
        exit 1
    fi
fi

# Change default shell to Zsh if not already set
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
else
    info "Zsh is already set as the default shell."
fi

# Verify installation
info "Verifying installation..."
if command -v zsh &> /dev/null && [ -d "$HOME/.oh-my-zsh" ]; then
    info "✅ Zsh and Oh-My-Zsh installed successfully."
else
    error "❌ Installation failed. Please check for errors."
    exit 1
fi

info "Installation complete! Please restart your terminal."
