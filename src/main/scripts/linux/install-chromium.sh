#!/usr/bin/env bash

# Chromium Installation Script for Multiple OS
# This script installs Chromium Browser and related packages based on the detected OS

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

# Check if Chromium is already installed
if command_exists chromium-browser; then
    echo "Chromium Browser is already installed: $(chromium-browser --version)"
    exit 0
fi

echo "Chromium Browser is not installed. Attempting to install it..."

# Step 2: Install Chromium based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        echo "Detected Debian-based system."
        sudo apt-get update -y

        echo "Installing Chromium Browser (Open-source web browser)..."
        sudo apt-get install -y chromium-browser

        echo "Installing Chromium Browser L10N (Language packs)..."
        sudo apt-get install -y chromium-browser-l10n

        echo "Installing Chromium Codecs FFmpeg (Basic media codecs)..."
        sudo apt-get install -y chromium-codecs-ffmpeg

        echo "Installing Chromium Codecs FFmpeg Extra (Additional media codecs)..."
        sudo apt-get install -y chromium-codecs-ffmpeg-extra
        ;;

    manjaro|arch)
        echo "Detected Arch-based system."
        echo "Updating package database..."
        pamac update --force-refresh

        echo "Installing Chromium Browser (Open-source web browser)..."
        pamac install --no-confirm chromium

        echo "Installing FFmpeg (Media codecs for Chromium)..."
        pamac install --no-confirm ffmpeg
        ;;

    fedora)
        echo "Detected Fedora system."
        sudo dnf update -y

        echo "Installing Chromium Browser (Open-source web browser)..."
        sudo dnf install -y chromium

        echo "Installing FFmpeg (Media codecs for Chromium)..."
        sudo dnf install -y ffmpeg
        ;;

    centos|redhat)
        echo "Detected CentOS/Red Hat system."
        sudo yum update -y

        echo "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        echo "Installing Chromium Browser (Open-source web browser)..."
        sudo yum install -y chromium

        echo "Installing FFmpeg (Media codecs for Chromium)..."
        sudo yum install -y ffmpeg
        ;;

    opensuse)
        echo "Detected openSUSE system."
        sudo zypper refresh

        echo "Installing Chromium Browser (Open-source web browser)..."
        sudo zypper install -y chromium

        echo "Installing FFmpeg (Media codecs for Chromium)..."
        sudo zypper install -y ffmpeg
        ;;

    alpine)
        echo "Detected Alpine Linux."
        sudo apk update

        echo "Installing Chromium Browser (Open-source web browser)..."
        sudo apk add chromium

        echo "Installing FFmpeg (Media codecs for Chromium)..."
        sudo apk add ffmpeg
        ;;

    macos)
        if command_exists brew; then
            echo "Using Homebrew to install Chromium Browser..."
            brew install --cask chromium
        else
            echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;

    linux)
        echo "Detected a generic Linux distribution. Attempting to install via snap..."
        if command_exists snap; then
            echo "Installing Chromium Browser via snap..."
            sudo snap install chromium
        else
            echo "Snap is not installed. Please install Snap or use your package manager to install Chromium Browser."
            exit 1
        fi
        ;;

    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
echo "Verifying Chromium Browser installation..."
if command_exists chromium-browser || command_exists chromium; then
    echo "✅ Chromium Browser successfully installed: $(chromium-browser --version 2>/dev/null || chromium --version)"
else
    echo "❌ Chromium Browser installation failed. Please try installing it manually."
    exit 1
fi

echo "Chromium Browser installation completed successfully on $OS."
