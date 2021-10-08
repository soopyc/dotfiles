#!/bin/bash

# I like to see progress when they're being done, hence all the verbose flags
# - helps with debugging too!

# A python script is probably better though(at least it should look way better), 
# but not all systems have python preinstalled..
# Perhaps install python here and then run the script.

CONFIGS=(
    .p10k.zsh 
    .zshrc
)

echo "*** kcomain's dotfiles"
echo ""
echo "*** this script requires: ln, mkdir, chmod"
echo "*** ln output with \`~' means a backup has been created."
echo ""

echo "*** Installing configuration files"

for item in ${CONFIGS[@]}; do
    ln -bsv $HOME/dotfiles/$item ~/$item
done

echo "*** Installing binaries"
mkdir -pv ~/.local/bin
ln -bsv $HOME/dotfiles/bin/* ~/.local/bin/

echo "*** Setting up permissions"
chmod -vR +x ./bin/*

echo "*** To install packages, run ./packages.sh"
echo "!!! All done!"

