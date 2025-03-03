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

# Check if git is already installed
if command -v git &> /dev/null; then
    info "Git is already installed: $(git --version)"
    exit 0
fi

# Step 2: Install Git, Git Flow, and Curl based on the detected OS
case "$OS" in
    ubuntu|debian|raspbian|wsl)
        info "Updating package database for $OS..."
        sudo apt-get update -y

        info "Installing Git (Version control system)..."
        sudo apt-get install -y git

        info "Installing Git Flow (Branch management for Git)..."
        sudo apt-get install -y git-flow

        info "Installing Curl (Command-line tool for transferring data)..."
        sudo apt-get install -y curl
        ;;

    manjaro|arch)
        info "Updating package database for $OS..."
        pamac update --force-refresh

        info "Installing Git (Version control system)..."
        pamac install --no-confirm git

        info "Installing Curl (Command-line tool for transferring data)..."
        pamac install --no-confirm curl

        # Check if git-flow is available in the official repo
        if pamac info git-flow &>/dev/null; then
            info "Installing Git Flow (Branch management for Git)..."
            pamac install --no-confirm git-flow
        else
            warning "Git Flow not found in the official repositories."

            # Check if yay is installed
            if ! command -v yay &>/dev/null; then
                info "Installing yay (AUR helper)..."
                pamac install --no-confirm yay
            fi

            info "Installing Git Flow from AUR..."
            yay -S --noconfirm gitflow-avh
        fi
        ;;

    fedora)
        info "Updating package database for Fedora..."
        sudo dnf update -y

        info "Installing Git and Curl..."
        sudo dnf install -y git curl

        info "Installing Git Flow..."
        sudo dnf install -y gitflow
        ;;

    centos|redhat)
        info "Detected CentOS/Red Hat system."
        sudo yum update -y
        sudo yum install -y epel-release

        info "Installing Git and Curl..."
        sudo yum install -y git curl

        info "Installing Git Flow..."
        sudo yum install -y gitflow
        ;;

    opensuse)
        info "Detected openSUSE system."
        sudo zypper refresh

        info "Installing Git and Curl..."
        sudo zypper install -y git curl

        info "Installing Git Flow..."
        sudo zypper install -y git-flow
        ;;

    alpine)
        info "Detected Alpine Linux."
        sudo apk update

        info "Installing Git and Curl..."
        sudo apk add git curl

        info "Git Flow is not available on Alpine. You can install it manually if needed."
        ;;

    macos)
        if command -v brew &> /dev/null; then
            info "Using Homebrew to install Git..."
            brew install git

            info "Installing Curl via Homebrew..."
            brew install curl

            info "Installing Git Flow via Homebrew..."
            brew install git-flow-avh
        else
            error "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        ;;

    linux)
        info "Detected a generic Linux distribution. Attempting to install via snap..."
        if command -v snap &> /dev/null; then
            info "Installing Git via snap..."
            sudo snap install git

            info "Installing Curl via snap..."
            sudo snap install curl
        else
            error "Snap is not installed. Please install Snap or use your package manager to install Git and Curl."
            exit 1
        fi
        ;;

    *)
        error "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Step 3: Verify installation
info "Verifying Git installation..."
git --version

info "Verifying Git Flow installation..."
if command -v git-flow &> /dev/null; then
    info "✅ Git Flow installed successfully."
else
    warning "❌ Git Flow installation failed or not available on this OS."
fi

info "Verifying Curl installation..."
curl --version

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
