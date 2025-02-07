#!/bin/bash
# Update package database
echo "Updating package database..."
pamac update --force-refresh

# Install CopyQ
echo "Installing CopyQ..."
pamac install --no-confirm copyq

# Verify installation
echo "Verifying CopyQ installation..."
if command -v copyq &> /dev/null; then
    echo "CopyQ installed successfully."
else
    echo "CopyQ installation failed. Please check for errors."
fi
