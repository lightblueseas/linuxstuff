#!/usr/bin/env bash

# G'MIC Installation Script for Multiple OS
# This script installs GIMP and the G'MIC plugin based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["gimp"]="GNU Image Manipulation Program."
    ["gmic"]="GREYC's Magic for Image Computing."
    ["gimp-gmic"]="G'MIC Plugin for GIMP."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch)
        descriptions=(
            ["gimp"]="GNU Image Manipulation Program."
            ["gmic"]="GREYC's Magic for Image Computing."
            ["gimp-plugin-gmic"]="G'MIC Plugin for GIMP."
        )
        ;;
    fedora|centos|redhat|opensuse)
        descriptions=(
            ["gimp"]="GNU Image Manipulation Program."
            ["gmic"]="GREYC's Magic for Image Computing."
            ["gmic-gimp"]="G'MIC Plugin for GIMP."
        )
        ;;
    macos)
        descriptions=(
            ["gimp"]="GNU Image Manipulation Program."
            ["gmic"]="GREYC's Magic for Image Computing."
        )
        ;;
esac

# Check if each component is already installed
check_installed() {
    if command -v $1 &> /dev/null; then
        info "$1 is already installed. Skipping installation."
        return 0
    else
        return 1
    fi
}

# Check and add missing components to the installation list
for package in "${!descriptions[@]}"; do
    if check_installed $package; then
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=($package)
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All GIMP and G'MIC components are already installed. Exiting."
    exit 0
fi

# Run sudo only if there are packages to install
info "Components to install: ${TO_INSTALL[*]}"

# Step 2: Install missing components based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Detected Debian-based system. Updating package database..."
            sudo apt-get update -y && sudo apt-get upgrade -y
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on $OS..."
                sudo apt-get install -y "$component"
            done
        fi
        ;;

    manjaro|arch)
        info "Detected Arch-based system."

        # Check if packages are already installed using pacman
        MISSING_PACKAGES=()
        for component in "${TO_INSTALL[@]}"; do
            if pacman -Qq "$component" &> /dev/null; then
                info "$component is already installed. Skipping installation."
            else
                MISSING_PACKAGES+=("$component")
            fi
        done

        # Exit if no packages are missing
        if [[ ${#MISSING_PACKAGES[@]} -eq 0 ]]; then
            info "All requested components are already installed. Exiting."
            exit 0
        fi

        # Update package database and install missing packages
        info "Updating package database for $OS..."
        pamac update --force-refresh

        for component in "${MISSING_PACKAGES[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            pamac install --no-confirm "$component"
        done
        ;;

    fedora|centos|redhat)
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Detected RPM-based system. Updating package database..."
            sudo dnf update -y || sudo yum update -y
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on $OS..."
                sudo dnf install -y "$component" || sudo yum install -y "$component"
            done
        fi
        ;;

    opensuse)
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Detected openSUSE system. Updating package database..."
            sudo zypper refresh
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on openSUSE..."
                sudo zypper install -y "$component"
            done
        fi
        ;;

    alpine)
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Detected Alpine Linux. Updating package database..."
            sudo apk update
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on Alpine..."
                sudo apk add "$component"
            done
        fi
        ;;

    macos)
        if command -v brew &> /dev/null && [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
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

    linux)
        if command -v snap &> /dev/null && [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Detected a generic Linux distribution. Attempting to install via snap..."
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component via snap (${descriptions[$component]})..."
                sudo snap install "$component"
            done
        else
            error "Snap is not installed. Please install Snap or use your package manager to install GIMP and G'MIC."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying G'MIC installation..."
for component in "${TO_INSTALL[@]}"; do
    if command -v "$component" &> /dev/null; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

# Step 4: Display G'MIC version
if command -v gmic &> /dev/null; then
    gmic --version
fi

info "Installation complete! You can now use G'MIC in GIMP under Filters → G’MIC-Qt."

