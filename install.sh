#!/bin/bash -e

# I like to see progress when they're being done, hence all the verbose flags
# - helps with debugging too!

# A python script is probably better though(at least it should look way better), 
# but not all systems have python preinstalled..
# Perhaps install python here and then run the script.

CONFIGS=(
    .p10k.zsh 
    .zshrc
    .makepkg.conf
)

echo "*** soopyc's dotfiles"
echo ""
echo "*** this script requires: ln, mkdir, chmod, curl"
echo "*** ln output with \`~' means a backup has been created."
echo ""

echo "*** Installing omz"
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "*** Installing configuration files"

for item in ${CONFIGS[@]}; do
    ln -bsv $PWD/$item ~/$item
done

mkdir -pv ~/.config/swaylock
ln -bsv $PWD/config/swaylock ~/.config/swaylock/config

echo "*** Installing binaries"
mkdir -pv ~/.local/bin
ln -bsv $HOME/dotfiles/bin/* ~/.local/bin/

echo "*** Setting up permissions"
chmod -vR +x ./bin/*

echo "*** Installing themes and other 3rd party configs"
echo "** p10k"
bash $HOME/dotfiles/install/p10k.sh

echo "*** To install packages, run ./packages.sh"
echo "!!! All done!"

