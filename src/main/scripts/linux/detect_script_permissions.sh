#!/usr/bin/env bash

# Script to check if a given script is executable and fix permissions if necessary

# Path to print_messages.sh
PRINT_MESSAGES_SCRIPT="./print_messages.sh"

# Check if print_messages.sh exists and is executable
if [[ ! -f "$PRINT_MESSAGES_SCRIPT" ]]; then
    echo "[ERROR] print_messages.sh not found. Please make sure it is in the same directory."
    exit 1
elif [[ ! -x "$PRINT_MESSAGES_SCRIPT" ]]; then
    echo "[WARNING] print_messages.sh is not executable. Attempting to fix permissions..."
    chmod +x "$PRINT_MESSAGES_SCRIPT"
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to add execute permissions to print_messages.sh. Please run: chmod +x $PRINT_MESSAGES_SCRIPT"
        exit 1
    else
        echo "[INFO] Permissions fixed for print_messages.sh."
    fi
fi

# Source the print_messages.sh to use the functions
source $PRINT_MESSAGES_SCRIPT

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
