#!/bin/bash

# Function to detect the distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif command -v lsb_release >/dev/null 2>&1; then
        echo "$(lsb_release -si | tr '[:upper:]' '[:lower:]')"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)

echo "Detected distribution: $DISTRO"

install_wecker() {
    case "$DISTRO" in
        arch|manjaro)
            echo "Installing GNOME Clocks on Manjaro/Arch..."
            sudo pacman -S --noconfirm gnome-clocks
            ;;
        ubuntu|debian)
            echo "Installing GNOME Clocks on Ubuntu/Debian..."
            sudo apt update && sudo apt install -y gnome-clocks
            ;;
        fedora)
            echo "Installing GNOME Clocks on Fedora..."
            sudo dnf install -y gnome-clocks
            ;;
        opensuse*)
            echo "Installing GNOME Clocks on openSUSE..."
            sudo zypper install -y gnome-clocks
            ;;
        *)
            echo "Unknown distribution. Attempting Snap installation..."
            if command -v snap >/dev/null 2>&1; then
                sudo snap install gnome-clocks
            else
                echo "Snap is not installed. Please install manually."
                exit 1
            fi
            ;;
    esac
}

install_wecker
echo "Installation complete. You can now start GNOME Clocks."
