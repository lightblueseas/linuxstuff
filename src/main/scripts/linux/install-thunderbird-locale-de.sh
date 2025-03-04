#!/usr/bin/env bash

# Thunderbird Installation Script for Multiple OS
# This script installs Thunderbird and German language support based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["thunderbird"]="Mozilla Thunderbird email client."
    ["thunderbird-locale-de"]="German language pack for Thunderbird."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch)
        descriptions=(
            ["thunderbird"]="Mozilla Thunderbird email client."
            ["thunderbird-i18n-de"]="German language pack for Thunderbird."
        )
        ;;
    fedora|centos|redhat|opensuse)
        descriptions=(
            ["thunderbird"]="Mozilla Thunderbird email client."
            ["thunderbird-langpack-de"]="German language pack for Thunderbird."
        )
        ;;
    macos)
        descriptions=(
            ["thunderbird"]="Mozilla Thunderbird email client."
        )
        ;;
esac

# Prompt for password once and store it temporarily
if sudo -vn 2>&1 | grep -q "password"; then
    echo "Please enter your sudo password:"
    read -s SUDO_PASSWORD
fi

# Function to run sudo with stored password
run_sudo() {
    echo "$SUDO_PASSWORD" | sudo -S "$@"
}

# Check if each component is already installed
check_installed() {
    case "$OS" in
        manjaro|arch)
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
        *)
            return 1
            ;;
    esac
}

# Check and add missing components to the installation list
for package in "${!descriptions[@]}"; do
    if check_installed "$package"; then
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All Thunderbird components are already installed. Exiting."
    exit 0
fi

# Run sudo only if there are packages to install
info "Components to install: ${TO_INSTALL[*]}"

# Step 2: Install missing components based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Detected Debian-based system. Updating package database..."
        run_sudo apt-get update -y
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            run_sudo apt-get install -y "$component"
        done
        ;;

    manjaro|arch)
        info "Detected Arch-based system."
        MISSING_PACKAGES=()
        for component in "${TO_INSTALL[@]}"; do
            if pacman -Qi "$component" &> /dev/null; then
                info "$component is already installed. Skipping installation."
            else
                MISSING_PACKAGES+=("$component")
            fi
        done

        if [[ ${#MISSING_PACKAGES[@]} -eq 0 ]]; then
            info "All requested components are already installed. Exiting."
            exit 0
        fi

        info "Updating package database for $OS..."
        run_sudo pamac update --force-refresh --no-confirm

        for component in "${MISSING_PACKAGES[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            run_sudo pamac install --no-confirm "$component"
        done
        ;;

    fedora|centos|redhat)
        info "Detected RPM-based system. Updating package database..."
        run_sudo dnf update -y || run_sudo yum update -y
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            run_sudo dnf install -y "$component" || run_sudo yum install -y "$component"
        done
        ;;

    opensuse)
        info "Detected openSUSE system. Updating package database..."
        run_sudo zypper refresh
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on openSUSE..."
            run_sudo zypper install -y "$component"
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
info "Verifying Thunderbird and its language pack installation..."
for component in "${TO_INSTALL[@]}"; do
    if check_installed "$component"; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

info "Thunderbird and its components installation completed successfully on $OS."
