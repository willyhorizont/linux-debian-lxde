#!/bin/sh

STYLE_DIR="$HOME/willyhorizont.github.io/linux-debian-lxde/styles"

LX_DESKTOP_CONF="$HOME/.config/lxsession/LXDE/desktop.conf"
LX_AUTOSTART="$HOME/.config/lxsession/LXDE/autostart"
LX_RC="$HOME/.config/openbox/lxde-rc.xml"
OB_AUTOSTART="$HOME/.config/openbox/autostart"
OB_RC="$HOME/.config/openbox/rc.xml"

STYLE_SUBDIR="win"

SRC_LX_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/autostart"
SRC_LX_DESKTOP_CONF="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/desktop.conf"
SRC_OB_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/autostart"
SRC_OB_RC="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/rc.xml"

ln -sf "$SRC_LX_DESKTOP_CONF" "$LX_DESKTOP_CONF"
ln -sf "$SRC_LX_AUTOSTART" "$LX_AUTOSTART"
ln -sf "$SRC_OB_RC" "$LX_RC"
ln -sf "$SRC_OB_AUTOSTART" "$OB_AUTOSTART"
ln -sf "$SRC_OB_RC" "$OB_RC"

ln -sf "$STYLE_DIR/$STYLE_SUBDIR/start-desktop.sh" "$HOME/.config/openbox/start-desktop.sh"

mkdir -p ~/.local/share/plank/themes/WindowsTenStyle/
cp ~/willyhorizont.github.io/linux-debian-lxde/.local/share/plank/themes/WindowsTenStyle/dock.theme ~/.local/share/plank/themes/WindowsTenStyle/dock.theme
mkdir -p ~/.config/rofi && cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/rofi/* ~/.config/rofi/
mkdir -p ~/.config/polybar && cp -r ~/willyhorizont.github.io/linux-debian-lxde/.config/polybar/* ~/.config/polybar/
cp ~/willyhorizont.github.io/linux-debian-lxde/.config/i3/config ~/.config/i3/config
update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications
