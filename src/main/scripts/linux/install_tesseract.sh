#!/usr/bin/env bash

# Tesseract OCR Installation Script for Multiple OS
# This script installs Tesseract OCR on Debian-based Linux, Manjaro, or Windows using Chocolatey

# Source the common initialization script
source ./init_scripts.sh

# Create arrays for components
TO_INSTALL=()
SKIPPED=()

# Exclusion list for Manjaro (packages that are known to be unavailable)
EXCLUSION_LIST_MANJARO=("libtesseract-dev" "choco")

# Descriptions for each package
declare -A descriptions=(
    ["tesseract"]="Tesseract OCR engine."
    ["libtesseract-dev"]="Development files for Tesseract OCR."
    ["tesseract-data-eng"]="English language data for Tesseract."
    ["tesseract-data-deu"]="German language data for Tesseract."
)

# Enhanced function to check if a package is installed
check_installed() {
    case "$OS" in
        manjaro)
            if pacman -Qi "$1" &>/dev/null; then
                return 0
            else
                return 1
            fi
            ;;
        debian)
            dpkg -s "$1" &>/dev/null
            ;;
        windows)
            choco list --localonly | grep -q "^$1"
            ;;
        *)
            return 1
            ;;
    esac
}

# Enhanced function to check if a package is available
check_available() {
    case "$OS" in
        manjaro)
            if pacman -Si "$1" &>/dev/null || yay -Ss "$1" &>/dev/null; then
                return 0
            else
                return 1
            fi
            ;;
        debian)
            apt-cache show "$1" &>/dev/null
            ;;
        windows)
            choco search "$1" --exact &>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

# Check and add missing components to the installation list
for package in "${!descriptions[@]}"; do
    if [[ "$OS" == "manjaro" && " ${EXCLUSION_LIST_MANJARO[*]} " == *" $package "* ]]; then
        warning "$package is excluded for Manjaro. Skipping..."
        SKIPPED+=("$package")
    elif check_installed "$package"; then
        info "$package is already installed. Skipping installation."
    elif check_available "$package"; then
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    else
        warning "$package not available in repositories. Skipping..."
        SKIPPED+=("$package")
    fi
done

# Print skipped packages if any
if [[ ${#SKIPPED[@]} -gt 0 ]]; then
    info "The following packages were skipped due to unavailability or exclusion:"
    for package in "${SKIPPED[@]}"; do
        echo "- $package (${descriptions[$package]})"
    done
fi

# Exit if all packages are already installed or skipped
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "No packages to install. Exiting."
    exit 0
fi

# Print missing components to be installed
info "The following components are missing and will be installed:"
for component in "${TO_INSTALL[@]}"; do
    echo "- $component (${descriptions[$component]})"
done

# Install Tesseract based on OS
case "$OS" in
    "debian")
        info "Detected Debian-based system. Updating package database..."
        sudo apt-get update -y
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on Debian..."
            sudo apt-get install -y "$component"
        done
        ;;
    "manjaro")
        info "Detected Manjaro system."

        # Check if any package is actually missing before asking for the password
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Missing components detected. Updating package database..."
            sudo -S pamac update --force-refresh --no-confirm
        fi

        for component in "${TO_INSTALL[@]}"; do
            if pacman -Si "$component" &>/dev/null || yay -Ss "$component" &>/dev/null; then
                info "Installing $component (${descriptions[$component]}) on Manjaro..."
                sudo pamac install --no-confirm "$component"
            else
                warning "$component not found in official repositories or AUR. Skipping..."
                SKIPPED+=("$component")
            fi
        done
        ;;
    "windows")
        info "Detected Windows system. Checking Chocolatey installation..."
        if ! command -v choco &> /dev/null; then
            info "Chocolatey not found. Skipping Chocolatey installation."
            SKIPPED+=("choco")
        else
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component (${descriptions[$component]}) on Windows..."
                choco install -y "$component"
            done
        fi
        ;;
    *)
        error "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying Tesseract installation..."
for component in "${TO_INSTALL[@]}"; do
    if check_installed "$component"; then
        info "✅ $component installed successfully."
    elif [[ " ${SKIPPED[*]} " == *" $component "* ]]; then
        warning "⚠️ $component was skipped due to unavailability or exclusion."
    else
        error "❌ $component installation failed. Please check for errors."
    fi
done

# Print summary
info "Installation summary:"
if [[ ${#SKIPPED[@]} -gt 0 ]]; then
    info "Skipped packages:"
    for package in "${SKIPPED[@]}"; do
        echo "- $package (${descriptions[$package]})"
    done
fi

info "Tesseract installation process completed on $OS."
