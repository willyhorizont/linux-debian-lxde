#!/bin/sh

cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/rc.xml ~/.config/openbox/lxde-rc.xml
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/rc.xml ~/.config/openbox/rc.xml
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/openbox/autostart ~/.config/openbox/autostart
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxsession/LXDE/autostart ~/.config/lxsession/LXDE/autostart
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxsession/LXDE/desktop.conf ~/.config/lxsession/LXDE/desktop.conf
mkdir -p ~/.local/share/plank/themes/WindowsTenStyle/
cp ~/willyhorizont.github.io/linux-debian-lxde/.local/share/plank/themes/WindowsTenStyle/dock.theme ~/.local/share/plank/themes/WindowsTenStyle/dock.theme
mkdir -p ~/.config/rofi && cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/rofi/* ~/.config/rofi/
mkdir -p ~/.config/polybar && cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/polybar/* ~/.config/polybar/
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/i3/config ~/.config/i3/config
update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications
