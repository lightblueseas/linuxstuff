#!/usr/bin/env bash

# ClamAV Installation Script for Multiple OS
# This script installs ClamAV based on the detected OS

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

# Check if ClamAV is already installed
if command -v clamscan &> /dev/null; then
    info "ClamAV is already installed: $(clamscan --version 2>/dev/null | head -n 1)"
    exit 0
fi

info "ClamAV is not installed. Attempting to install it..."

# Step 2: Install ClamAV based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y

        info "Installing ClamAV on $OS..."
        sudo apt-get install -y clamav clamav-freshclam clamav-docs clamav-daemon clamtk clamtk-nautilus
        ;;

    manjaro|arch)
        info "Updating package database for $OS..."
        pamac update --force-refresh

        info "Installing ClamAV on $OS..."
        pamac install --no-confirm clamav clamtk
        ;;

    fedora)
        info "Updating package database for $OS..."
        sudo dnf update -y

        info "Installing ClamAV on $OS..."
        sudo dnf install -y clamav clamtk
        ;;

    centos|redhat)
        info "Updating package database for $OS..."
        sudo yum update -y

        info "Installing EPEL repository on $OS..."
        sudo yum install -y epel-release

        info "Installing ClamAV on $OS..."
        sudo yum install -y clamav clamtk
        ;;

    opensuse)
        info "Updating package database for $OS..."
        sudo zypper refresh

        info "Installing ClamAV on $OS..."
        sudo zypper install -y clamav clamtk
        ;;

    alpine)
        info "Updating package database for $OS..."
        sudo apk update

        info "Installing ClamAV on $OS..."
        sudo apk add clamav clamtk
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Homebrew is installed. Updating..."
            brew update

            info "Installing ClamAV on macOS..."
            brew install clamav
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            info "Installing ClamAV via snap..."
            sudo snap install clamav
        else
            error "Snap is not installed. Please install Snap or use your package manager to install ClamAV."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Enable and start ClamAV daemon if applicable
if [[ "$OS" != "macos" && "$OS" != "linux" ]]; then
    info "Enabling and starting ClamAV daemon..."
    sudo systemctl enable clamav-daemon
    sudo systemctl start clamav-daemon

    info "Checking ClamAV daemon status..."
    sudo systemctl status clamav-daemon

    info "Stopping ClamAV daemon before updating database..."
    sudo systemctl stop clamav-daemon

    info "Manually updating virus database..."
    sudo freshclam

    info "Restarting ClamAV daemon..."
    sudo systemctl start clamav-daemon
fi

# Step 4: Verify installation
info "Verifying ClamAV installation..."
if command -v clamscan &> /dev/null; then
    info "✅ ClamAV installed successfully."
else
    error "❌ ClamAV installation failed. Please check for errors."
    exit 1
fi

info "ClamAV installation and setup completed successfully on $OS."
