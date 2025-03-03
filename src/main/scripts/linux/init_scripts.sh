#!/usr/bin/env bash

# Common Initialization Script for External Scripts
# Ensures external scripts are executable and sources them

# Path to external scripts
PRINT_MESSAGES_SCRIPT="./print_messages.sh"
CHECK_PERMISSIONS_SCRIPT="./detect_script_permissions.sh"
DETECT_OS_SCRIPT="./detect_os.sh"

# Ensure external scripts exist and have execute permissions
for SCRIPT in "$PRINT_MESSAGES_SCRIPT" "$CHECK_PERMISSIONS_SCRIPT" "$DETECT_OS_SCRIPT"; do
    if [[ ! -f "$SCRIPT" ]]; then
        echo "[ERROR] $SCRIPT not found. Please make sure it is in the same directory."
        exit 1
    elif [[ ! -x "$SCRIPT" ]]; then
        echo "[WARNING] $SCRIPT is not executable. Attempting to fix permissions..."
        chmod +x "$SCRIPT"
        if [[ $? -ne 0 ]]; then
            echo "[ERROR] Failed to add execute permissions to $SCRIPT. Please run: chmod +x $SCRIPT"
            exit 1
        else
            echo "[INFO] Permissions fixed for $SCRIPT."
        fi
    fi
done

# Source the print messages script for logging functions
source $PRINT_MESSAGES_SCRIPT

# Run the permission check for detect_os.sh using detect_script_permissions.sh
$CHECK_PERMISSIONS_SCRIPT "$DETECT_OS_SCRIPT"
if [[ $? -ne 0 ]]; then
    error "Failed to ensure execute permissions for $DETECT_OS_SCRIPT"
    exit 1
fi

# Step 1: Detect OS using the external script
OS=$($DETECT_OS_SCRIPT)

# Check if the OS detection script ran successfully
if [[ -z "$OS" || "$OS" == "unknown" ]]; then
    error "Could not detect the OS or unsupported OS detected."
    exit 1
fi

info "Detected OS: $OS"
