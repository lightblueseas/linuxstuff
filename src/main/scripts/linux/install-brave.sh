#!/usr/bin/env bash

# Brave Browser Installation Script for Multiple OS
# This script installs Brave Browser based on the detected OS

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Detect OS using the external script
OS=$(./detect_os.sh)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    echo "Could not detect the OS or unsupported OS detected."
    exit 1
fi

echo "Detected OS: $OS"

# Check if Brave Browser is already installed
if command_exists brave-browser; then
    echo "Brave Browser is already installed: $(brave-browser --version 2>/dev/null)"
    exit 0
fi

echo "Brave Browser is not installed. Attempting to install it..."

# Step 2: Install Brave Browser based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        echo "Detected Debian-based system."
        if ! command_exists curl; then
            echo "curl is required to install Brave. Installing curl..."
            sudo apt-get update && sudo apt-get install -y curl
        fi
        if ! command_exists apt-transport-https; then
            echo "apt-transport-https is required. Installing it..."
            sudo apt-get update && sudo apt-get install -y apt-transport-https
        fi

        echo "Adding Brave Browser repository..."
        curl -s https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | sudo tee /usr/share/keyrings/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

        echo "Updating package lists and installing Brave Browser..."
        sudo apt-get update && sudo apt-get install -y brave-browser
        ;;

    manjaro|arch)
        echo "Detected Arch-based system."
        if command_exists yay; then
            echo "Using yay to install Brave Browser..."
            yay -S brave-bin --noconfirm
        elif command_exists paru; then
            echo "Using paru to install Brave Browser..."
            paru -S brave-bin --noconfirm
        else
            echo "Neither yay nor paru (AUR helpers) are installed. Please install one or install Brave Browser manually from AUR."
            exit 1
        fi
        ;;

    fedora)
        echo "Detected Fedora system."
        sudo dnf install dnf-plugins-core -y
        sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo dnf install -y brave-browser
        ;;

    centos|redhat)
        echo "Detected CentOS/Red Hat system."
        sudo yum install -y dnf
        sudo dnf install dnf-plugins-core -y
        sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo dnf install -y brave-browser
        ;;

    opensuse)
        echo "Detected openSUSE system."
        sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo zypper refresh
        sudo zypper install -y brave-browser
        ;;

    alpine)
        echo "Detected Alpine Linux."
        sudo apk update
        sudo apk add brave-browser
        ;;

    macos)
        if command_exists brew; then
            echo "Using Homebrew to install Brave Browser..."
            brew install --cask brave-browser
        else
            echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;

    linux)
        echo "Detected a generic Linux distribution. Attempting to install via snap..."
        if command_exists snap; then
            echo "Installing Brave Browser via snap..."
            sudo snap install brave
        else
            echo "Snap is not installed. Please install Snap or use your package manager to install Brave Browser."
            exit 1
        fi
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
echo "Verifying Brave Browser installation..."
if command_exists brave-browser; then
    echo "✅ Brave Browser successfully installed: $(brave-browser --version 2>/dev/null)"
else
    echo "❌ Brave Browser installation failed. Please try installing it manually from: https://brave.com/download/"
    exit 1
fi

echo "Installation process completed successfully on $OS."
