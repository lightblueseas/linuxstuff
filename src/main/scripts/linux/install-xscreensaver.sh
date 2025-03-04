#!/usr/bin/env bash

# Screensaver Installation Script for Multiple OS
# This script removes the deprecated gnome-screensaver and installs xscreensaver along with extra packages

# Source the common initialization script
source ./init_scripts.sh

# Create arrays for components to install, remove, missing, and unavailable
TO_INSTALL=()
TO_REMOVE=()
MISSING_COMPONENTS=()
UNAVAILABLE_COMPONENTS=()

# Descriptions for each package
declare -A descriptions=(
    ["gnome-screensaver"]="Deprecated GNOME screensaver package."
    ["xscreensaver"]="XScreenSaver, a popular screen saver and locker for the X Window System."
    ["xscreensaver-data-extra"]="Extra screensaver modules for XScreenSaver."
    ["xscreensaver-gl-extra"]="OpenGL-based screensaver modules for XScreenSaver."
)

# Check if a package is available in the repository
is_available() {
    case "$OS" in
        manjaro|arch)
            pamac search "$1" &>/dev/null || pacman -Ss "^$1$" &>/dev/null
            ;;
        ubuntu|debian|raspbian|wsl)
            apt-cache show "$1" &>/dev/null
            ;;
        fedora|centos|redhat|opensuse)
            yum list "$1" &>/dev/null || dnf list "$1" &>/dev/null
            ;;
        macos)
            brew info "$1" &>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if a package is installed
check_installed() {
    if command -v "$1" &>/dev/null || dpkg -s "$1" &>/dev/null; then
        info "$1 is already installed. Skipping installation."
        return 0
    else
        MISSING_COMPONENTS+=("$1")
        return 1
    fi
}

# Check if a package is installed for removal
check_installed_for_removal() {
    if dpkg -s "$1" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Check for gnome-screensaver and mark it for removal if installed and available
if is_available "gnome-screensaver"; then
    if check_installed_for_removal "gnome-screensaver"; then
        info "Preparing to remove ${descriptions["gnome-screensaver"]}"
        TO_REMOVE+=("gnome-screensaver")
    else
        info "gnome-screensaver is not installed. Skipping removal."
    fi
else
    warning "gnome-screensaver is not available in the repositories. Skipping removal."
fi

# Skip specific packages on Manjaro
if [[ "$OS" == "manjaro" || "$OS" == "arch" ]]; then
    SKIP_PACKAGES=("xscreensaver-data-extra" "xscreensaver-gl-extra")
else
    SKIP_PACKAGES=()
fi

# Check and add missing components to the installation list
for package in "xscreensaver" "xscreensaver-data-extra" "xscreensaver-gl-extra"; do
    # Skip packages if defined
    if [[ " ${SKIP_PACKAGES[*]} " == *" $package "* ]]; then
        warning "Skipping $package as it is not available on $OS."
        continue
    fi

    if ! is_available "$package"; then
        warning "$package is not available in the repositories. Skipping."
        UNAVAILABLE_COMPONENTS+=("$package")
        continue
    fi

    if check_installed "$package"; then
        continue
    else
        info "Preparing to install ${descriptions[$package]}"
        TO_INSTALL+=("$package")
    fi
done

# Print unavailable components if any
if [[ ${#UNAVAILABLE_COMPONENTS[@]} -gt 0 ]]; then
    echo "The following components are not available in the repositories and will be skipped:"
    for component in "${UNAVAILABLE_COMPONENTS[@]}"; do
        echo "- $component (${descriptions[$component]})"
    done
fi

# Exit if all packages are already installed and no removal is needed
if [[ ${#TO_INSTALL[@]} -eq 0 && ${#TO_REMOVE[@]} -eq 0 ]]; then
    info "All required components are already installed and no packages to remove. Exiting."
    exit 0
fi

# Print the components to be installed or removed
info "Components to install: ${TO_INSTALL[*]}"
info "Components to remove: ${TO_REMOVE[*]}"

# Only request sudo password if there are actual packages to install or remove
if [[ ${#TO_INSTALL[@]} -gt 0 || ${#TO_REMOVE[@]} -gt 0 ]]; then
    read -sp "Enter your sudo password: " SUDO_PASSWORD
    echo
else
    info "No installation or removal required. Exiting."
    exit 0
fi

# Step 2: Remove deprecated packages if necessary
if [[ ${#TO_REMOVE[@]} -gt 0 ]]; then
    info "Removing deprecated packages..."
    echo "$SUDO_PASSWORD" | sudo -S apt-get remove -y "${TO_REMOVE[@]}"
fi

# Step 3: Install missing components based on the detected OS
case "$OS" in
    manjaro|arch)
        info "Detected Arch-based system."
        if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
            info "Missing components detected. Updating package database..."
            echo "$SUDO_PASSWORD" | sudo -S pamac update --force-refresh --no-confirm
        else
            info "All required packages are already installed. Skipping pamac update."
        fi

        for component in "${TO_INSTALL[@]}"; do
            info "Installing $component (${descriptions[$component]}) on $OS..."
            echo "$SUDO_PASSWORD" | sudo -S pamac install --no-confirm "$component"
        done
        ;;
    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 4: Verify installation
info "Verifying XScreenSaver installation..."
for component in "${TO_INSTALL[@]}"; do
    if check_installed "$component"; then
        info "✅ $component installed successfully."
    else
        error "❌ $component installation failed. Please check for errors."
        exit 1
    fi
done

info "XScreenSaver and extensions installation completed successfully on $OS."
