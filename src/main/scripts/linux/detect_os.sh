#!/bin/bash

# Extended OS Detection Script
# Detects a wide range of operating systems and prints the result as a string

# Detect OS
ID=""  # Set ID to an empty string if /etc/os-release is not found

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
elif [[ -f /etc/rpi-issue ]]; then
    # Fallback for older Raspberry Pi OS versions
    ID="raspbian"
elif [[ "$(uname)" == "Darwin" ]]; then
    # Detect macOS
    ID="macos"
elif [[ "$(uname)" == "Linux" && -f /etc/alpine-release ]]; then
    # Detect Alpine Linux
    ID="alpine"
elif [[ "$(uname -r)" =~ Microsoft ]]; then
    # Detect Windows Subsystem for Linux (WSL)
    ID="wsl"
elif [[ "$(uname)" == "Linux" ]]; then
    # Generic Linux fallback
    ID="linux"
else
    # Unknown OS
    ID="unknown"
fi

# Additional detection for specific distros
if [[ -f /etc/os-release ]]; then
    if grep -qi 'raspbian' /etc/os-release; then
        ID="raspbian"
    elif grep -qi 'manjaro' /etc/os-release; then
        ID="manjaro"
    elif grep -qi 'arch' /etc/os-release; then
        ID="arch"
    elif grep -qi 'fedora' /etc/os-release; then
        ID="fedora"
    elif grep -qi 'centos' /etc/os-release; then
        ID="centos"
    elif grep -qi 'red hat' /etc/os-release; then
        ID="redhat"
    elif grep -qi 'opensuse' /etc/os-release; then
        ID="opensuse"
    elif grep -qi 'debian' /etc/os-release; then
        ID="debian"
    elif grep -qi 'ubuntu' /etc/os-release; then
        ID="ubuntu"
    fi
fi

# Print detected OS or 'unknown' if ID is empty
echo "${ID:-unknown}"
