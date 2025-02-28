#!/bin/bash

# Check if the system is Manjaro
if [[ ! -f /etc/manjaro-release ]]; then
    echo "This script is only for Manjaro!"
    exit 1
fi

echo "Manjaro detected. Starting installation of GNOME Calculator..."

# Check if pamac is available, otherwise fallback to pacman
if command -v pamac &>/dev/null; then
    echo "pamac found, using pamac for installation..."
    sudo pamac install gnome-calculator
else
    echo "pamac not found, using pacman for installation..."
    sudo pacman -S --noconfirm gnome-calculator
fi

echo "Installation completed. You can start the calculator with 'gnome-calculator'."
