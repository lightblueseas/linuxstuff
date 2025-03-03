#!/usr/bin/env bash

# QEMU and KVM Installation Script for Multiple OS
# This script installs QEMU, KVM, and related tools based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["qemu-kvm"]="KVM support for QEMU for hardware virtualization."
    ["libvirt-bin"]="Libvirt daemon and utilities for managing virtual machines."
    ["ubuntu-vm-builder"]="Tool for building virtual machine images on Ubuntu."
    ["bridge-utils"]="Utilities for configuring network bridges for VMs."
    ["virt-manager"]="Graphical interface for managing virtual machines."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch)
        descriptions=(
            ["qemu"]="QEMU emulator for virtual machines."
            ["libvirt"]="Libvirt daemon and utilities for managing virtual machines."
            ["bridge-utils"]="Utilities for configuring network bridges for VMs."
            ["virt-manager"]="Graphical interface for managing virtual machines."
        )
        ;;
    fedora|centos|redhat|opensuse)
        descriptions=(
            ["qemu-kvm"]="KVM support for QEMU for hardware virtualization."
            ["libvirt"]="Libvirt daemon and utilities for managing virtual machines."
            ["bridge-utils"]="Utilities for configuring network bridges for VMs."
            ["virt-manager"]="Graphical interface for managing virtual machines."
        )
        ;;
    macos)
        descriptions=(
            ["qemu"]="QEMU emulator for virtual machines."
        )
        ;;
esac

# Enhanced function to check if a package is installed
check_installed() {
    case "$OS" in
        manjaro|arch)
            pacman -Qi "$1" &>/dev/null
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
    info "All QEMU, KVM, and related components are already installed. Exiting."
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
            pamac install --no-confirm "$component"
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
    linux)
        if command -v snap &> /dev/null; then
            info "Detected a generic Linux distribution. Attempting to install via snap..."
            for component in "${TO_INSTALL[@]}"; do
                info "Installing $component via snap (${descriptions[$component]})..."
                sudo snap install "$component"
            done
        else
            error "Snap is not installed. Please install Snap or use your package manager to install QEMU and KVM."
            exit 1
        fi
        ;;
    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying QEMU, KVM, and related components installation..."
for component in "${TO_INSTALL[@]}"; do
    if check_installed "$component"; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

info "QEMU, KVM, and related components installation completed successfully on $OS."
