#!/bin/sh

cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxsession/LXDE/autostart ~/.config/lxsession/LXDE/autostart
cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/jgmenu/* ~/.config/jgmenu/
mkdir -p ~/.local/share/plank/themes/WindowsTenStyle/
cp ~/willyhorizont.github.io/linux-debian-lxde/.local/share/plank/themes/WindowsTenStyle/dock.theme ~/.local/share/plank/themes/WindowsTenStyle/dock.theme
setsid bash -c "$HOME/willyhorizont.github.io/linux-debian-lxde/restart-desktop.sh" >/dev/null 2>&1 &
