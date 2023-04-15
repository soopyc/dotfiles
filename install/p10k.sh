#!/bin/bash
FONTS=(
	https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
	https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
	https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
	https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
)
install_fonts() {
    if [ $EUID -e 0 ]; then
        FONTDIR=/usr/local/share/fonts/m/
    else
        FONTDIR=$HOME/.local/share/fonts
    fi
    mkdir -p $FONTDIR
    for font in "$FONTS[@]"; do
        curl -Lo $FONTDIR/$(basename $font) $font
    done
}

install_color_scheme() {
    curl -Lo $HOME/.local/share/konsole/ https://github.com/arcticicestudio/nord-konsole/raw/develop/src/nord.colorscheme
    curl -Lo $HOME/.local/share/konsole/ https://github.com/catppuccin/konsole/raw/main/Catppuccin-Latte.colorscheme
    curl -Lo $HOME/.local/share/konsole/ https://github.com/catppuccin/konsole/raw/main/Catppuccin-Mocha.colorscheme
}

