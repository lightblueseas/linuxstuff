#!/bin/bash

# Enable logging
exec > >(tee -i install.log)
exec 2>&1

# Function to check if a command exists
command_exists() { type "$1" &> /dev/null; }

# Function to detect package manager and install package
install_package() {
    local package="$1"

    if command_exists apt; then
        sudo apt update && sudo apt install -y "$package"
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm "$package"
    elif command_exists dnf; then
        sudo dnf install -y "$package"
    elif [[ -f /etc/os-release ]] && grep -qi "opensuse" /etc/os-release; then
        sudo zypper install -y "$package"
    elif command_exists brew; then
        brew install "$package"
    else
        echo "Unsupported package manager. Please install $package manually."
        exit 1
    fi
}

# Ensure the script is run with appropriate privileges
if [[ $EUID -ne 0 ]]; then
    echo "Warning: This script may require sudo privileges."
    echo "If you encounter issues, try running it with: sudo $0"
fi

# Install Pandoc
if command_exists pandoc; then
    echo "Pandoc is already installed: $(pandoc --version | head -n 1)"
else
    echo "Pandoc is not installed. Attempting to install it..."
    install_package pandoc
fi

# Verify Pandoc installation
if command_exists pandoc; then
    echo "Pandoc successfully installed: $(pandoc --version | head -n 1)"
else
    echo "Pandoc installation failed. Please try installing it manually."
    exit 1
fi

# Install LaTeX (pdflatex)
if command_exists pdflatex; then
    echo "LaTeX is already installed: $(pdflatex --version | head -n 1)"
else
    echo "LaTeX is not installed. Attempting to install it..."

    if command_exists apt; then
        install_package "texlive texlive-latex-extra"
    elif command_exists pacman; then
        install_package "texlive-core texlive-bin texlive-latexextra texlive-fontsextra"
    elif command_exists dnf; then
        install_package "texlive"
    elif [[ -f /etc/os-release ]] && grep -qi "opensuse" /etc/os-release; then
        install_package "texlive"
    elif command_exists brew; then
        install_package "mactex"
    else
        echo "Unsupported OS for LaTeX installation. You may need to install it manually."
    fi
fi

# Verify LaTeX installation
if command_exists pdflatex; then
    echo "LaTeX successfully installed: $(pdflatex --version | head -n 1)"
else
    echo "LaTeX installation failed. Attempting to install wkhtmltopdf instead..."

    # Install wkhtmltopdf as an alternative PDF engine
    install_package "wkhtmltopdf"

    # Check if wkhtmltopdf was installed successfully
    if command_exists wkhtmltopdf; then
        echo "wkhtmltopdf successfully installed: $(wkhtmltopdf --version)"
    else
        echo "PDF support installation failed. You may need to install pdflatex or wkhtmltopdf manually."
    fi
fi

echo "Installation complete!"
