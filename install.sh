#!/bin/sh

cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/rc.xml ~/.config/openbox/lxde-rc.xml
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/rc.xml ~/.config/openbox/rc.xml
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/autostart ~/.config/openbox/autostart
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxsession/LXDE/autostart ~/.config/lxsession/LXDE/autostart
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxsession/LXDE/desktop.conf ~/.config/lxsession/LXDE/desktop.conf
cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/jgmenu/* ~/.config/jgmenu/
mkdir -p ~/.config/rofi && cp ~/willyhorizont.github.io/linux-debian-lxde/.config/rofi/config.rasi ~/.config/rofi/config.rasi
mkdir -p ~/.config/rofi && cp ~/willyhorizont.github.io/linux-debian-lxde/.config/rofi/main-menu.sh ~/.config/rofi/main-menu.sh
mkdir -p ~/.config/polybar && cp ~/willyhorizont.github.io/linux-debian-lxde/.config/polybar/config.ini ~/.config/polybar/config.ini
mkdir -p ~/.local/share/plank/themes/WindowsTenStyle/
cp ~/willyhorizont.github.io/linux-debian-lxde/.local/share/plank/themes/WindowsTenStyle/dock.theme ~/.local/share/plank/themes/WindowsTenStyle/dock.theme
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/i3/config ~/.config/i3/config
