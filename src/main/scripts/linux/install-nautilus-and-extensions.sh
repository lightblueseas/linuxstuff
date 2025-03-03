#!/usr/bin/env bash

# Nautilus and Extensions Installation Script for Multiple OS
# This script installs Nautilus and various Nautilus extensions based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["nautilus"]="Nautilus file manager."
    ["nautilus-admin"]="Adds administrative actions to Nautilus context menu."
    ["nautilus-sendto"]="Enables sending files directly from Nautilus."
    ["nautilus-image-converter"]="Adds image resizing and rotation options in Nautilus context menu."
    ["nautilus-compare"]="Adds file comparison options in Nautilus context menu."
    ["nautilus-wipe"]="Adds secure delete options in Nautilus."
    ["seahorse-nautilus"]="Encryption and decryption integration for Nautilus."
    ["nautilus-gtkhash"]="Checksums and hash generation for files in Nautilus."
    ["nautilus-share"]="Enables file sharing in Nautilus."
    ["nautilus-script-manager"]="Manages custom scripts in Nautilus."
    ["ffmpegthumbnailer"]="Generates video thumbnails for Nautilus."
    ["nautilus-actions"]="Custom actions for files in Nautilus."
    ["nautilus-gksu"]="Open files as administrator in Nautilus."
    ["nautilus-actions-extra"]="Extra custom actions for Nautilus."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch)
        descriptions=(
            ["nautilus"]="Nautilus file manager."
            ["nautilus-admin"]="Adds administrative actions to Nautilus context menu."
            ["nautilus-sendto"]="Enables sending files directly from Nautilus."
            ["nautilus-image-converter"]="Adds image resizing and rotation options in Nautilus context menu."
            ["nautilus-compare"]="Adds file comparison options in Nautilus context menu."
            ["nautilus-wipe"]="Adds secure delete options in Nautilus."
            ["seahorse-nautilus"]="Encryption and decryption integration for Nautilus."
            ["nautilus-gtkhash"]="Checksums and hash generation for files in Nautilus."
            ["nautilus-share"]="Enables file sharing in Nautilus."
            ["nautilus-script-manager"]="Manages custom scripts in Nautilus."
            ["ffmpegthumbnailer"]="Generates video thumbnails for Nautilus."
        )
        ;;
esac

# Check if each component is already installed without using sudo
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
        info "$package is already installed. Skipping installation."
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All Nautilus components are already installed. Exiting."
    exit 0
fi

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
            if pamac search "$component" &> /dev/null; then
                info "Installing $component (${descriptions[$component]}) on $OS..."
                pamac install --no-confirm "$component"
            else
                warning "$component not found in official repositories. Trying AUR..."
                if yay -Ss "$component" &> /dev/null; then
                    info "Installing $component from AUR..."
                    yay -S --noconfirm "$component"
                else
                    warning "$component not found in AUR either. Skipping."
                fi
            fi
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

# Step 3: Verify installation
info "Verifying Nautilus and its extensions installation..."
for component in "${TO_INSTALL[@]}"; do
    if check_installed "$component"; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

info "Nautilus and extensions installation completed successfully on $OS."
