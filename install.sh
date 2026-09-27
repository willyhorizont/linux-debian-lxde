#!/bin/sh

cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxsession/LXDE/autostart ~/.config/lxsession/LXDE/autostart
cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/jgmenu/* ~/.config/jgmenu/
cp ~/willyhorizont.github.io/linux-debian-lxde/.local/share/plank/themes/PinnedPlusOpenedWindowList/dock.theme ~/.local/share/plank/themes/PinnedPlusOpenedWindowList/dock.theme
~/willyhorizont.github.io/linux-debian-lxde/restart-desktop.sh
