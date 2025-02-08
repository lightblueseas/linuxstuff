#!/bin/bash

# Automated SDKMAN! Installation Script
# Supports Ubuntu/Debian and Manjaro (Arch-based) systems

set -e  # Exit on error

# Function to check OS type
detect_os() {
    if [[ -f "/etc/os-release" ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "Unsupported OS"
        exit 1
    fi
}

# Function to install dependencies
install_dependencies() {
    local os_type=$1
    echo "Installing dependencies..."

    case "$os_type" in
        ubuntu|debian)
            sudo apt update && sudo apt install -y curl zip unzip
            ;;
        manjaro|arch)
            sudo pacman -Syu --noconfirm curl zip unzip
            ;;
        *)
            echo "Unsupported OS detected."
            exit 1
            ;;
    esac

    echo "Dependencies installed successfully."
}

# Function to install SDKMAN!
install_sdkman() {
    echo "Installing SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash

    # Initialize SDKMAN!
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    # Verify installation
    if sdk version; then
        echo "SDKMAN! installed successfully."
    else
        echo "SDKMAN! installation failed."
        exit 1
    fi
}

# Function to install a specific Java version
install_java() {
    local java_version=$1
    echo "Installing Java version: $java_version..."

    sdk install java "$java_version"

    echo "Java $java_version installed successfully."
}

# Detect OS
OS_TYPE=$(detect_os)
echo "Detected OS: $OS_TYPE"

# Install dependencies
install_dependencies "$OS_TYPE"

# Install SDKMAN!
install_sdkman

# Prompt for Java version installation
read -p "Enter Java version to install (e.g., 21.0.4-tem): " JAVA_VERSION
if [[ -n "$JAVA_VERSION" ]]; then
    install_java "$JAVA_VERSION"
else
    echo "Skipping Java installation."
fi

echo "Installation process completed successfully!"
