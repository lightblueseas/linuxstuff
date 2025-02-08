#!/usr/bin/env bash

# Detect OS
if [[ -f /etc/debian_version ]]; then
    echo "Detected Debian-based system"
    sudo apt-get update
    sudo apt-get install -y git git-flow curl
elif [[ -f /etc/arch-release ]]; then
    echo "Detected Arch-based system"
    sudo pacman -Sy --noconfirm git curl

    # Check if git-flow is available
    if pacman -Si git-flow &>/dev/null; then
        sudo pacman -Sy --noconfirm git-flow
    else
        echo "git-flow not found in the official repositories."

        # Check if yay is installed, otherwise install it
        if ! command -v yay &>/dev/null; then
            echo "Installing yay (AUR helper)..."
            sudo pacman -S --noconfirm yay
        fi

        # Install git-flow using yay
        echo "Installing git-flow from AUR..."
        yay -S --noconfirm gitflow-avh
    fi
else
    echo "Unsupported OS. Please install git manually."
    exit 1
fi

# Verify installation
git --version

# Check git config
if ! git config --get user.name >/dev/null 2>&1; then
    echo "Git user.name is not set. Please configure it."
    echo "Example: git config --global user.name 'Your Name'"
fi

if ! git config --get user.email >/dev/null 2>&1; then
    echo "Git user.email is not set. Please configure it."
    echo "Example: git config --global user.email 'your.email@example.com'"
fi

echo "Git installation completed successfully."