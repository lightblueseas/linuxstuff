#!/usr/bin/env bash

# Chromium Installation Script for Multiple OS
# This script installs Chromium Browser and related packages based on the detected OS

# Path to external scripts
PRINT_MESSAGES_SCRIPT="./print_messages.sh"
CHECK_PERMISSIONS_SCRIPT="./detect_script_permissions.sh"
DETECT_OS_SCRIPT="./detect_os.sh"

# Ensure external scripts exist and have execute permissions
for SCRIPT in "$PRINT_MESSAGES_SCRIPT" "$CHECK_PERMISSIONS_SCRIPT" "$DETECT_OS_SCRIPT"; do
    if [[ ! -f "$SCRIPT" ]]; then
        echo "[ERROR] $SCRIPT not found. Please make sure it is in the same directory."
        exit 1
    elif [[ ! -x "$SCRIPT" ]]; then
        echo "[WARNING] $SCRIPT is not executable. Attempting to fix permissions..."
        chmod +x "$SCRIPT"
        if [[ $? -ne 0 ]]; then
            echo "[ERROR] Failed to add execute permissions to $SCRIPT. Please run: chmod +x $SCRIPT"
            exit 1
        else
            echo "[INFO] Permissions fixed for $SCRIPT."
        fi
    fi
done

# Source the print messages script
source $PRINT_MESSAGES_SCRIPT

# Run the permission check for detect_os.sh using detect_script_permissions.sh
$CHECK_PERMISSIONS_SCRIPT "$DETECT_OS_SCRIPT"
if [[ $? -ne 0 ]]; then
    error "Failed to ensure execute permissions for $DETECT_OS_SCRIPT"
    exit 1
fi

# Step 1: Detect OS using the external script
OS=$($DETECT_OS_SCRIPT)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    error "Could not detect the OS or unsupported OS detected."
    exit 1
fi

info "Detected OS: $OS"

# Function to check if a package is installed
check_installed() {
    case "$OS" in
        ubuntu|debian|raspbian|wsl)
            dpkg -s "$1" &> /dev/null
            ;;
        manjaro|arch)
            pacman -Qi "$1" &> /dev/null
            ;;
        fedora|centos|redhat|opensuse)
            rpm -q "$1" &> /dev/null
            ;;
        alpine)
            apk info "$1" &> /dev/null
            ;;
        macos)
            brew list "$1" &> /dev/null
            ;;
        linux)
            snap list "$1" &> /dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

# Create an array for packages to install
to_install=()

# Descriptions for each package
declare -A descriptions=(
    ["chromium-browser"]="Open-source web browser."
    ["chromium-browser-l10n"]="Language packs for Chromium Browser."
    ["chromium-codecs-ffmpeg"]="Basic media codecs for Chromium."
    ["chromium-codecs-ffmpeg-extra"]="Additional media codecs for Chromium."
)

# Check and add missing packages to the installation list
for package in "${!descriptions[@]}"; do
    if check_installed $package; then
        info "$package is already installed. Skipping."
    else
        info "Preparing to install ${descriptions[$package]}"
        to_install+=($package)
    fi
done

# Exit if all packages are already installed
if [[ ${#to_install[@]} -eq 0 ]]; then
    info "All packages are already installed. Exiting."
    exit 0
fi

info "Chromium Browser is not fully installed. Attempting to install missing components..."

# Step 2: Install missing packages based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y
        for package in "${to_install[@]}"; do
            info "Installing $package..."
            sudo apt-get install -y $package
        done
        ;;

    manjaro|arch)
        info "Detected Arch-based system."
        pamac update --force-refresh
        for package in "${to_install[@]}"; do
            info "Installing $package..."
            pamac install --no-confirm $package
        done
        ;;

    fedora|centos|redhat|opensuse)
        info "Detected RPM-based system."
        sudo dnf update -y || sudo yum update -y
        for package in "${to_install[@]}"; do
            info "Installing $package..."
            sudo dnf install -y $package || sudo yum install -y $package
        done
        ;;

    alpine)
        info "Detected Alpine Linux."
        sudo apk update
        for package in "${to_install[@]}"; do
            info "Installing $package..."
            sudo apk add $package
        done
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Using Homebrew to install missing packages..."
            brew update
            for package in "${to_install[@]}"; do
                info "Installing $package..."
                brew install --cask $package
            done
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            for package in "${to_install[@]}"; do
                info "Installing $package via snap..."
                sudo snap install $package
            done
        else
            error "Snap is not installed. Please install Snap or use your package manager to install Chromium Browser."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying Chromium Browser installation..."
for package in "${to_install[@]}"; do
    if check_installed $package; then
        info "✅ $package installed successfully."
    else
        error "❌ $package installation failed. Please check for errors."
    fi
done

info "Chromium Browser installation completed successfully on $OS."
