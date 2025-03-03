#!/usr/bin/env bash

# Node.js and npm Installation Script for Multiple OS
# This script installs Node.js, npm, and sets up necessary permissions for global npm packages

# Source the common initialization script if it exists
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["nodejs"]="JavaScript runtime built on Chrome's V8 JavaScript engine."
    ["npm"]="Node Package Manager for managing JavaScript packages."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch)
        descriptions["n"]="Node version manager for managing multiple versions of Node.js."
        ;;
    macos)
        descriptions["node"]="JavaScript runtime built on Chrome's V8 JavaScript engine."
        ;;
esac

# Check if each component is already installed
check_installed() {
    case "$OS" in
        manjaro|arch)
            pacman -Qs "$1" &> /dev/null
            ;;
        ubuntu|debian|raspbian|wsl)
            dpkg -s "$1" &> /dev/null
            ;;
        fedora|centos|redhat|opensuse)
            rpm -q "$1" &> /dev/null
            ;;
        macos)
            brew list "$1" &> /dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

# Check and add missing components to the installation list
for package in "${!descriptions[@]}"; do
    if check_installed "$package"; then
        echo "$package is already installed. Skipping installation."
    else
        echo "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    echo "All Node.js components are already installed. Exiting."
    exit 0
fi

echo "Components to install: ${TO_INSTALL[*]}"

# Install missing components
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        echo "Detected Debian-based system. Updating package database..."
        echo "$USER password might be required for sudo access."
        sudo apt-get update -y
        sudo apt-get install -y "${TO_INSTALL[@]}"
        ;;
    manjaro|arch)
        echo "Detected Arch-based system. Checking and installing missing packages..."
        echo "$USER password might be required for sudo access."
        pamac update --force-refresh
        pamac install --no-confirm "${TO_INSTALL[@]}"
        ;;
    fedora|centos|redhat|opensuse)
        echo "Detected RPM-based system. Updating package database..."
        echo "$USER password might be required for sudo access."
        sudo dnf update -y || sudo yum update -y
        sudo dnf install -y "${TO_INSTALL[@]}" || sudo yum install -y "${TO_INSTALL[@]}"
        ;;
    macos)
        if command -v brew &> /dev/null; then
            echo "Homebrew is installed. Updating..."
            brew update
            brew install "${TO_INSTALL[@]}"
        else
            echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Create node_modules directory if not exists and fix permissions
NODE_MODULES_DIR="/usr/local/lib/node_modules"
if [ ! -d "$NODE_MODULES_DIR" ]; then
    echo "Creating node_modules directory at $NODE_MODULES_DIR..."
    sudo mkdir -p "$NODE_MODULES_DIR"
else
    echo "node_modules directory already exists at $NODE_MODULES_DIR."
fi

echo "Changing ownership of $NODE_MODULES_DIR to $USER..."
sudo chown -R "$USER" "$NODE_MODULES_DIR"

# Verify installation
echo "Verifying Node.js and npm installation..."
for component in "${TO_INSTALL[@]}"; do
    if check_installed "$component"; then
        echo "✅ $component installed successfully."
    else
        echo "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

echo "Node.js and npm installation completed successfully on $OS."
