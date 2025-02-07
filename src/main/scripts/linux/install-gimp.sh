#!/usr/bin/env bash

echo "Updating package list..."
sudo apt update -y

# Check if GIMP is already installed
if command -v gimp &> /dev/null; then
    echo "GIMP is already installed. Skipping installation."
else
    echo "Installing GIMP and additional plugins..."
    sudo apt install -y \
        gimp \
        gimp-help-de \
        language-pack-gnome-de \
        gimp-dcraw \
        gimp-ufraw \
        gimp-gap \
        gimp-gutenprint \
        gimp-plugin-registry \
        gimp-resynthesizer \
        gimp-python \
        gmic
fi

echo "GIMP installation complete!"
