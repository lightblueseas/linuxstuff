#!/usr/bin/env bash

# Python Graph Visualization Tools Installation Script for Multiple OS
# This script installs python-pydot, python-pydot-ng, and graphviz based on the detected OS

# Source the common initialization script
source ./init_scripts.sh

# Create an array for components to install
TO_INSTALL=()

# Descriptions for each package (default for Ubuntu/Debian)
declare -A descriptions=(
    ["python-pydot"]="Python interface to Graphviz's DOT language."
    ["python-pydot-ng"]="Fork of pydot with additional features and fixes."
    ["graphviz"]="Graph visualization software for creating diagrams."
)

# Adjust package names based on the OS
case "$OS" in
    manjaro|arch)
        descriptions=(
            ["python-pydot"]="Python interface to Graphviz's DOT language."
            ["python-pygraphviz"]="Python interface for Graphviz with more features."
            ["graphviz"]="Graph visualization software for creating diagrams."
        )
        ;;
    fedora|centos|redhat|opensuse)
        descriptions=(
            ["python3-pydot"]="Python 3 interface to Graphviz's DOT language."
            ["python3-pygraphviz"]="Python 3 interface for Graphviz."
            ["graphviz"]="Graph visualization software for creating diagrams."
        )
        ;;
    macos)
        descriptions=(
            ["pydot"]="Python interface to Graphviz's DOT language."
            ["pygraphviz"]="Python interface for Graphviz."
            ["graphviz"]="Graph visualization software for creating diagrams."
        )
        ;;
esac

# Enhanced function to check if a package is installed
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
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    fi
done

# Exit if all packages are already installed
if [[ ${#TO_INSTALL[@]} -eq 0 ]]; then
    info "All Python Graph Visualization Tools are already installed. Exiting."
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

    alpine)
        info "Detected Alpine Linux. Updating package database..."
        sudo apk update
        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on Alpine..."
            sudo apk add "$component"
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
            error "Snap is not installed. Please install Snap or use your package manager to install the components."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying Python Graph Visualization Tools installation..."
for component in "${TO_INSTALL[@]}"; do
    if check_installed "$component"; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

info "Python Graph Visualization Tools installation completed successfully on $OS."
