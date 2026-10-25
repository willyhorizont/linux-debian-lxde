#!/bin/bash

SCRIPT_NAME="kb-lxde-openbox-desktop-selector-prompt.sh"

case 0 in
    $(pgrep -x "lxsession" >/dev/null; echo $?))
        ;;
    $(pgrep -x "openbox" >/dev/null; echo $?))
        ;;
    *)
        notify-send "$SCRIPT_NAME" "Error: Session not match!"
        exit 1
        ;;
esac

STYLE_DIR="$HOME/willyhorizont.github.io/linux-debian-lxde/styles"

LX_DESKTOP_CONF="$HOME/.config/lxsession/LXDE/desktop.conf"
LX_AUTOSTART="$HOME/.config/lxsession/LXDE/autostart"
LX_RC="$HOME/.config/openbox/lxde-rc.xml"
OB_AUTOSTART="$HOME/.config/openbox/autostart"
OB_RC="$HOME/.config/openbox/rc.xml"

mkdir -p "$HOME/.config/lxsession/LXDE"
mkdir -p "$HOME/.config/openbox"

SELECTION=$(rofi -dmenu -i -p "Choose LXDE Openbox Style" << 'EOF'
Windows 7/10 Style
Mac Style
Linux Tiling Style
Linux Floating Style
EOF
)

if [ -z "$SELECTION" ]; then
    exit 0
fi

case "$SELECTION" in
    "Windows 7/10 Style")
        STYLE_SUBDIR="win"
        ;;
    "Mac Style")
        STYLE_SUBDIR="mac"
        ;;
    "Linux Tiling Style")
        STYLE_SUBDIR="tiling"
        ;;
    "Linux Floating Style")
        STYLE_SUBDIR="floating"
        ;;
    *)
        notify-send "$SCRIPT_NAME" "Error: Invalid input!"
        exit 1
        ;;
esac

SRC_LX_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/autostart"
SRC_LX_DESKTOP_CONF="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/desktop.conf"
SRC_OB_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/autostart"
SRC_OB_RC="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/rc.xml"

ln -sf "$SRC_LX_DESKTOP_CONF" "$LX_DESKTOP_CONF"
ln -sf "$SRC_LX_AUTOSTART" "$LX_AUTOSTART"
ln -sf "$SRC_OB_RC" "$LX_RC"
ln -sf "$SRC_OB_AUTOSTART" "$OB_AUTOSTART"
ln -sf "$SRC_OB_RC" "$OB_RC"

sh -c '"$HOME/.config/openbox/start-desktop.sh --kill"'
ln -sf "$STYLE_DIR/$STYLE_SUBDIR/start-desktop.sh" "$HOME/.config/openbox/start-desktop.sh"
sh -c '"$HOME/.config/openbox/start-desktop.sh"'

notify-send "$SCRIPT_NAME" "$SELECTION chosen"
