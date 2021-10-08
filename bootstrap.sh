#!/bin/bash
# This script installs python to run the actual script. this name is temporary and will be
# renamed to install.sh when i'm finally done writing the python code.

arch() {
    echo "Executing arch-specific commands"
    echo "Installing python..."
    sudo pacman -Sy
    sudo pacman -S python
}