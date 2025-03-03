#!/usr/bin/env bash

# Okular and Extensions Installation Script for Multiple OS
# This script installs Okular and its additional format support based on user choice

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package
declare -A descriptions=(
    ["okular"]="Document viewer for PDFs, eBooks, and more."
    ["okular-extra-backends"]="Provides support for EPUB, TIFF, DjVu, and other formats."
    ["okular-backend-odp"]="Supports OpenDocument Presentation (ODP), PowerPoint, and PPTX formats."
    ["okular-backend-odt"]="Supports OpenDocument Text (ODT), DOC, DOCX, RTF, and WPD formats."
    ["okular-mobile"]="Provides support for mobile formats (FictionBook, Plucker, CHM, XML Document Format)."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch)
        descriptions=(
            ["okular"]="Document viewer for PDFs, eBooks, and more."
        )
        ;;
esac

# Enhanced function to check if a package is installed
check_installed() {
    case "$OS" in
        manjaro|arch)
            # Check if package is installed using pacman
            if pacman -Qi "$1" &>/dev/null; then
                info "$1 is already installed. Skipping installation."
                return 0
            else
                return 1
            fi
            ;;
        ubuntu|debian|raspbian|wsl)
            dpkg -s "$1" &>/dev/null
            ;;
        fedora|centos|redhat|opensuse)
            rpm -q "$1" &>/dev/null
            ;;
        macos)
            brew list "$1" &>/dev/null
            ;;
        linux)
            snap list "$1" &>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if each component is already installed
if check_installed "okular"; then
    info "Okular is already installed."
else
    info "Preparing to install Okular..."
    TO_INSTALL+=("okular")
fi

# Ask user if they want to install additional format support
echo "Soll die erweiterte Formatunterstützung installiert werden? ([Y]/n)"
read -r INSTALL_EXTRA

# Set default value if no input
INSTALL_EXTRA=${INSTALL_EXTRA:-Y}

if [[ "${INSTALL_EXTRA^^}" == "Y" ]]; then
    # Check and add missing additional format support packages
    for package in "okular-extra-backends" "okular-backend-odp" "okular-backend-odt" "okular-mobile"; do
        if [[ "$OS" == "manjaro" || "$OS" == "arch" ]]; then
            info "Checking if $package is available on Manjaro/Arch..."
            if pacman -Ss "$package" &>/dev/null; then
                info "$package is available. Adding to install list."
                TO_INSTALL+=("$package")
            else
                warning "$package is not available on Manjaro/Arch. Skipping."
            fi
        else
            if check_installed "$package"; then
                continue
            else
                info "Preparing to install ${descriptions[$package]}"
                TO_INSTALL+=("$package")
            fi
        fi
    done
else
    info "Erweiterte Formatunterstützung wird nicht installiert."
fi

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All Okular components are already installed. Exiting."
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
            info "Installing $component (${descriptions[$component]}) on $OS..."
            if pamac install --no-confirm "$component"; then
                info "$component installed successfully."
            else
                warning "$component could not be installed. Skipping."
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
esac

# Step 3: Verify installation
info "Verifying Okular and its extensions installation..."
for component in "${TO_INSTALL[@]}"; do
    if check_installed "$component"; then
        info "✅ $component installed successfully."
    else
        warning "❌ $component installation failed or not available."
    fi
done

info "Okular and extensions installation completed successfully on $OS."
