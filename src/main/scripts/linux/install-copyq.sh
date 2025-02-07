#!/bin/bash

# Function to check the OS type
check_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

OS=$(check_os)

if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    # Update package database
    echo "Updating package database..."
    sudo apt-get update

    # Install CopyQ
    echo "Installing CopyQ..."
    sudo apt-get install -y copyq

elif [[ "$OS" == "manjaro" || "$OS" == "arch" ]]; then
    # Update package database
    echo "Updating package database..."
    pamac update --force-refresh

    # Install CopyQ
    echo "Installing CopyQ..."
    pamac install --no-confirm copyq
else
    echo "Unsupported OS: $OS"
    exit 1
fi

# Verify installation
echo "Verifying CopyQ installation..."
if command -v copyq &> /dev/null; then
    echo "CopyQ installed successfully."
else
    echo "CopyQ installation failed. Please check for errors."
fi
