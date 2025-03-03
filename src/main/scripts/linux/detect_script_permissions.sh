#!/usr/bin/env bash

# Script to check if a given script is executable and fix permissions if necessary

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

# Check if a script path was provided
if [[ -z "$1" ]]; then
    error "Usage: $0 <path_to_script>"
    exit 1
fi

SCRIPT_PATH="$1"

# Check if the script exists
if [[ ! -f "$SCRIPT_PATH" ]]; then
    error "Script not found: $SCRIPT_PATH"
    exit 1
fi

# Check if the script is executable
if [[ ! -x "$SCRIPT_PATH" ]]; then
    warning "Script $SCRIPT_PATH is not executable. Attempting to fix permissions..."
    chmod +x "$SCRIPT_PATH"

    if [[ $? -ne 0 ]]; then
        error "Failed to add execute permissions to $SCRIPT_PATH. Please run: chmod +x $SCRIPT_PATH"
        exit 1
    else
        info "Permissions fixed for $SCRIPT_PATH."
    fi
else
    info "Script $SCRIPT_PATH is already executable."
fi
