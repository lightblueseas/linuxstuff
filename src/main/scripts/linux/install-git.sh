#!/usr/bin/env bash

# Git Installation Script for Multiple OS
# This script installs Git, Git Flow, and Curl based on the detected OS

# Colors for output
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# Function to print messages
info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# Step 1: Detect OS using the external script
OS=$(./detect_os.sh)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    error "Could not detect the OS or unsupported OS detected."
    exit 1
fi

info "Detected OS: $OS"

# Flags to track installation status
CURL_INSTALLED=false
GIT_INSTALLED=false
GIT_FLOW_INSTALLED=false

# Check if Curl is already installed
if command -v curl &> /dev/null; then
    info "Curl is already installed: $(curl --version | head -n 1)"
    CURL_INSTALLED=true
else
    info "Curl is not installed. Attempting to install it..."
fi

# Check if Git is already installed
if command -v git &> /dev/null; then
    info "Git is already installed: $(git --version)"
    GIT_INSTALLED=true
else
    info "Git is not installed. Attempting to install it..."
fi

# Check if Git Flow is already installed
if command -v git-flow &> /dev/null; then
    info "Git Flow is already installed: $(git-flow version)"
    GIT_FLOW_INSTALLED=true
else
    info "Git Flow is not installed. Attempting to install it..."
fi

# Step 2: Install Curl, Git, and Git Flow based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        sudo apt-get update -y
        if [ "$CURL_INSTALLED" = false ]; then
            info "Installing Curl..."
            sudo apt-get install -y curl
        fi
        if [ "$GIT_INSTALLED" = false ]; then
            info "Installing Git..."
            sudo apt-get install -y git
        fi
        if [ "$GIT_FLOW_INSTALLED" = false ]; then
            info "Installing Git Flow..."
            sudo apt-get install -y git-flow
        fi
        ;;

    manjaro|arch)
        pamac update --force-refresh
        if [ "$CURL_INSTALLED" = false ]; then
            info "Installing Curl..."
            pamac install --no-confirm curl
        fi
        if [ "$GIT_INSTALLED" = false ]; then
            info "Installing Git..."
            pamac install --no-confirm git
        fi
        if [ "$GIT_FLOW_INSTALLED" = false ]; then
            info "Installing Git Flow..."
            if pamac info git-flow &>/dev/null; then
                pamac install --no-confirm git-flow
            else
                warning "Git Flow not found in the official repositories. Installing from AUR..."
                if ! command -v yay &>/dev/null; then
                    info "Installing yay (AUR helper)..."
                    pamac install --no-confirm yay
                fi
                yay -S --noconfirm gitflow-avh
            fi
        fi
        ;;

    fedora)
        sudo dnf update -y
        if [ "$CURL_INSTALLED" = false ]; then
            info "Installing Curl..."
            sudo dnf install -y curl
        fi
        if [ "$GIT_INSTALLED" = false ]; then
            info "Installing Git..."
            sudo dnf install -y git
        fi
        if [ "$GIT_FLOW_INSTALLED" = false ]; then
            info "Installing Git Flow..."
            sudo dnf install -y gitflow
        fi
        ;;

    macos)
        if command -v brew &> /dev/null; then
            if [ "$CURL_INSTALLED" = false ]; then
                info "Installing Curl via Homebrew..."
                brew install curl
            fi
            if [ "$GIT_INSTALLED" = false ]; then
                info "Installing Git via Homebrew..."
                brew install git
            fi
            if [ "$GIT_FLOW_INSTALLED" = false ]; then
                info "Installing Git Flow via Homebrew..."
                brew install git-flow-avh
            fi
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
if command -v curl &> /dev/null; then
    info "✅ Curl successfully installed."
else
    error "❌ Curl installation failed."
fi

if command -v git &> /dev/null; then
    info "✅ Git successfully installed."
else
    error "❌ Git installation failed."
fi

if command -v git-flow &> /dev/null; then
    info "✅ Git Flow successfully installed."
else
    warning "❌ Git Flow installation failed or not available on this OS."
fi

# Check git config
if ! git config --get user.name >/dev/null 2>&1; then
    warning "Git user.name is not set. Please configure it."
    echo "Example: git config --global user.name 'Your Name'"
fi

if ! git config --get user.email >/dev/null 2>&1; then
    warning "Git user.email is not set. Please configure it."
    echo "Example: git config --global user.email 'your.email@example.com'"
fi

info "Git installation completed successfully."
