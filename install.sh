#!/bin/sh

cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/rc.xml ~/.config/openbox/lxde-rc.xml
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/rc.xml ~/.config/openbox/rc.xml
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/autostart ~/.config/openbox/autostart
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxsession/LXDE/autostart ~/.config/lxsession/LXDE/autostart
cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/jgmenu/* ~/.config/jgmenu/
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/rofi/config.rasi ~/.config/rofi/config.rasi
mkdir -p ~/.local/share/plank/themes/WindowsTenStyle/
cp ~/willyhorizont.github.io/linux-debian-lxde/.local/share/plank/themes/WindowsTenStyle/dock.theme ~/.local/share/plank/themes/WindowsTenStyle/dock.theme
openbox --reconfigure
setsid bash -c "$HOME/willyhorizont.github.io/linux-debian-lxde/restart-desktop.sh" >/dev/null 2>&1 &
