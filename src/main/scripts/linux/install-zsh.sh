#!/usr/bin/env bash

# Zsh Installation Script for Multiple OS
# This script installs Zsh and sets it as the default shell based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package
declare -A descriptions=(
    ["zsh"]="Zsh shell for command line interface with advanced features."
)

# Detect OS
ID=""  # Set ID to an empty string if /etc/os-release is not found
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
elif [[ -f /etc/rpi-issue ]]; then
    ID="raspbian"  # Fallback for older Raspberry Pi OS versions
else
    warn "Could not determine OS file. Continuing with ID as empty string."
fi

# Check for Raspberry Pi OS explicitly
if grep -qi 'raspbian' /etc/os-release 2>/dev/null; then
    ID="raspbian"
fi

info "Detected OS: ${ID:-unknown}"

# Check if Zsh is already installed
if command -v zsh &> /dev/null; then
    info "zsh is already installed: $(zsh --version)"
else
    info "Preparing to install Zsh shell for command line interface with advanced features."
    TO_INSTALL+=("zsh")
fi

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All required components are already installed. Exiting."
    exit 0
fi

# Run sudo only if there are packages to install
info "Components to install: ${TO_INSTALL[*]}"

# Step 2: Install missing components based on the detected OS
case "$ID" in
    manjaro|arch)
        info "Detected Arch-based system."
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            # Check for missing packages
            MISSING_PACKAGES=()
            for component in "${TO_INSTALL[@]}"; do
                if pacman -Qq "$component" &> /dev/null; then
                    info "$component is already installed. Skipping installation."
                else
                    MISSING_PACKAGES+=("$component")
                fi
            done

            # Print missing components
            if [[ ${#MISSING_PACKAGES[@]} -gt 0 ]]; then
                info "The following components are missing and will be installed:"
                for component in "${MISSING_PACKAGES[@]}"; do
                    echo "- $component (${descriptions[$component]})"
                done
            else
                info "All required components are already installed. Exiting."
                exit 0
            fi

            # Update package database and install missing packages
            sudo -S pamac update --force-refresh --no-confirm
            for component in "${MISSING_PACKAGES[@]}"; do
                info "Installing $component (${descriptions[$component]}) on $ID..."
                sudo -S pamac install --no-confirm "$component"
            done
        fi
        ;;

    ubuntu|debian|raspbian|wsl)
        info "Detected Debian-based system."
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            sudo apt-get update -y
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on $ID..."
                sudo apt-get install -y "$component"
            done
        fi
        ;;

    *)
        error "Unsupported OS: $ID"
        exit 1
        ;;
esac

# Verify Zsh installation
if command -v zsh &> /dev/null; then
    info "✅ Zsh successfully installed: $(zsh --version)"
else
    error "❌ Zsh installation failed. Please try installing it manually."
    exit 1
fi

# Set Zsh as the default shell
ZSH_PATH=$(which zsh)
if [[ -z "$ZSH_PATH" ]]; then
    error "❌ Zsh not found in PATH. Exiting."
    exit 1
fi

info "Setting Zsh as default shell for user: $USER"
echo "$PASSWORD" | sudo -S chsh -s "$ZSH_PATH" "$USER"

# Verify the default shell change
info "Your current shell is: $SHELL"

# Prompt user to log out or restart if needed
info "If the output above is still /bin/bash, please log out or reboot."

info "When you open Zsh for the first time, you may see a configuration menu."
info "Follow the prompts to configure your shell."

info "To verify again, run: echo \$SHELL"

info "Zsh installation and configuration completed successfully on $ID."
