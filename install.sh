#!/bin/sh

STYLE_DIR="$HOME/willyhorizont.github.io/linux-debian-lxde/styles"

LX_DESKTOP_CONF="$HOME/.config/lxsession/LXDE/desktop.conf"
LX_AUTOSTART="$HOME/.config/lxsession/LXDE/autostart"
LX_RC="$HOME/.config/openbox/lxde-rc.xml"
OB_AUTOSTART="$HOME/.config/openbox/autostart"
OB_RC="$HOME/.config/openbox/rc.xml"

DEFAULT_STYLE_FILE="$HOME/willyhorizont.github.io/linux-debian-lxde/styles/default.txt"

DEFAULT_STYLE=$(cat "$DEFAULT_STYLE_FILE" | xargs)

if [ -z "$DEFAULT_STYLE" ]; then
    notify-send "$SCRIPT_NAME" "Error: '$DEFAULT_STYLE_FILE' invalid!"
    exit 1
fi

if [ ! -d "$STYLE_DIR/$DEFAULT_STYLE" ]; then
    notify-send "$SCRIPT_NAME" "Error: directory '$STYLE_DIR/$DEFAULT_STYLE' not found!"
    exit 1
fi

SRC_LX_AUTOSTART="$STYLE_DIR/$DEFAULT_STYLE/.config/lxsession/LXDE/autostart"
SRC_LX_DESKTOP_CONF="$STYLE_DIR/$DEFAULT_STYLE/.config/lxsession/LXDE/desktop.conf"
SRC_OB_AUTOSTART="$STYLE_DIR/$DEFAULT_STYLE/.config/openbox/autostart"
SRC_OB_RC="$STYLE_DIR/$DEFAULT_STYLE/.config/openbox/rc.xml"

ln -sf "$SRC_LX_DESKTOP_CONF" "$LX_DESKTOP_CONF"
ln -sf "$SRC_LX_AUTOSTART" "$LX_AUTOSTART"
ln -sf "$SRC_OB_RC" "$LX_RC"
ln -sf "$SRC_OB_AUTOSTART" "$OB_AUTOSTART"
ln -sf "$SRC_OB_RC" "$OB_RC"

ln -sf "$STYLE_DIR/$DEFAULT_STYLE/start-desktop.sh" "$HOME/.config/openbox/start-desktop.sh"

mkdir -p ~/.local/share/plank/themes/windows-7-or-10-style/
cp ~/willyhorizont.github.io/linux-debian-lxde/.local/share/plank/themes/windows-7-or-10-style/dock.theme ~/.local/share/plank/themes/windows-7-or-10-style/dock.theme
# cp ~/willyhorizont.github.io/linux-debian-lxde/.Xresources ~/.Xresources
# xrdb -merge ~/.Xresources
mkdir -p ~/.config/lxterminal/ && cp ~/willyhorizont.github.io/linux-debian-lxde/.config/lxterminal/lxterminal.conf ~/.config/lxterminal/lxterminal.conf
mkdir -p ~/.config/rofi/ && cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/rofi/* ~/.config/rofi/
mkdir -p ~/.config/polybar/ && cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/polybar/* ~/.config/polybar/
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/i3/config ~/.config/i3/config
update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications
