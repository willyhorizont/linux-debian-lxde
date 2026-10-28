#!/bin/sh

mkdir -p ~/.local/share/plank/themes/windows-7-or-10-style/
cp ~/willyhorizont.github.io/linux-debian-lxde/.local/share/plank/themes/windows-7-or-10-style/dock.theme ~/.local/share/plank/themes/windows-7-or-10-style/dock.theme
mkdir -p ~/.config/lxterminal/ && cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxterminal/lxterminal.conf ~/.config/lxterminal/lxterminal.conf
mkdir -p ~/.config/dunst/ && cp ~/willyhorizont.github.io/linux-debian-lxde/.config/dunst/dunstrc ~/.config/dunst/dunstrc
mkdir -p ~/.config/rofi/ && cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/rofi/* ~/.config/rofi/
mkdir -p ~/.config/polybar/ && cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/polybar/* ~/.config/polybar/
cp ~/willyhorizont.github.io/linux-debian-lxde/.Xresources ~/.Xresources
xrdb -merge ~/.Xresources
CMD_SET_CUR_DESKTOP='sh -c "$HOME/willyhorizont.github.io/linux-debian-lxde/set-env-current-desktop.sh"'
grep -qxF "$CMD_SET_CUR_DESKTOP" ~/.profile || echo "$CMD_SET_CUR_DESKTOP" >> ~/.profile
update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications

sh -c "$HOME/willyhorizont.github.io/linux-debian-lxde/style-selector.sh --default"
sh -c "$HOME/willyhorizont.github.io/linux-debian-lxde/i3/style-selector.sh --default"
