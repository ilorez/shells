#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install GParted
install_gparted() {
    if command_exists apt-get; then
        # Debian, Ubuntu, Linux Mint
        sudo apt-get update
        sudo apt-get install -y gparted
    elif command_exists yay; then
        # Arch-based systems with yay
        yay -S --noconfirm gparted
    elif command_exists pacman; then
        # Arch Linux, Manjaro
        sudo pacman -Sy --noconfirm gparted
    elif command_exists dnf; then
        # Fedora
        sudo dnf install -y gparted
    elif command_exists yum; then
        # CentOS, RHEL
        sudo yum install -y gparted
    elif command_exists zypper; then
        # openSUSE
        sudo zypper install -y gparted
    elif command_exists apk; then
        # Alpine Linux
        sudo apk add gparted
    elif command_exists emerge; then
        # Gentoo
        sudo emerge --ask=n sys-block/gparted
    else
        echo "Error: Unable to detect package manager. Please install GParted manually."
        exit 1
    fi
}

# Check if GParted is installed
if ! command_exists gparted; then
    echo "GParted is not installed. Attempting to install..."
    install_gparted
else
    echo "GParted is already installed."
fi

# Run GParted with elevated privileges
echo "Running GParted..."
if command_exists pkexec; then
    pkexec gparted
else
    sudo gparted
fi
