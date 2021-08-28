#!/bin/bash

CONFIGS=(
    .p10k.zsh 
    .zshrc
)

echo "Installing configuration files"

for item in ${CONFIGS[@]}; do
    ln -sv $HOME/dotfiles/$item ~/$item
done

echo "Installing binaries"
mkdir -pv ~/.local/bin
ln -sv $HOME/dotfiles/bin/* ~/.local/bin/
