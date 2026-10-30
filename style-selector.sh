#!/bin/bash

SCRIPT_NAME="style-selector.sh"

USE_DEFAULT=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --default)
            USE_DEFAULT=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

STYLE_DIR="$HOME/willyhorizont.github.io/linux-debian-lxde/styles/"
DEFAULT_STYLE_FILE="$STYLE_DIR/default.txt"
DEFAULT_STYLE=$(cat "$DEFAULT_STYLE_FILE" | xargs)

if [ -z "$DEFAULT_STYLE" ]; then
    notify-send "$SCRIPT_NAME" "Error: '$DEFAULT_STYLE_FILE' invalid!"
    exit 1
fi

if [ ! -d "$STYLE_DIR/$DEFAULT_STYLE" ]; then
    notify-send "$SCRIPT_NAME" "Error: directory '$STYLE_DIR/$DEFAULT_STYLE' not found!"
    exit 1
fi

LX_DESKTOP_CONF="$HOME/.config/lxsession/LXDE/desktop.conf"
LX_AUTOSTART="$HOME/.config/lxsession/LXDE/autostart"
LX_RC="$HOME/.config/openbox/lxde-rc.xml"
OB_AUTOSTART="$HOME/.config/openbox/autostart"
OB_RC="$HOME/.config/openbox/rc.xml"

START_MENU="$HOME/willyhorizont.github.io/.config/rofi-config-windows-start-menu.rasi"
TASKBAR="$HOME/willyhorizont.github.io/.config/plank.ini"
BOTTOM_PANEL_MENU="$HOME/willyhorizont.github.io/.config/tint2-bottom-panel-menu"
BOTTOM_UPPER_PANEL="$HOME/willyhorizont.github.io/.config/tint2-bottom-upper-panel"
BOTTOM_PANEL="$HOME/willyhorizont.github.io/.config/tint2-bottom-panel"
TOP_BAR="$HOME/willyhorizont.github.io/.config/tint2-top-bar"

if [ "$USE_DEFAULT" = true ]; then
    STYLE_SUBDIR="$DEFAULT_STYLE"
    
    README_FILE="$STYLE_DIR/$STYLE_SUBDIR/README.md"
    if [ -f "$README_FILE" ]; then
        SELECTION=$(head -n 1 "$README_FILE" | sed 's/^#[[:space:]]*//' | xargs)
    fi
    
    if [ -z "$SELECTION" ]; then
        SELECTION="$DEFAULT_STYLE"
    fi
else
    ROFI_OPTIONS=""
    declare -A STYLE_MAP

    process_dir() {
        local style_subdir="$1"
        local README_FILE="$STYLE_DIR/$style_subdir/README.md"
        if [ -f "$README_FILE" ]; then
            local TITLE=$(head -n 1 "$README_FILE" | sed 's/^#[[:space:]]*//' | xargs)
            if [ -n "$TITLE" ]; then
                if [ -z "$ROFI_OPTIONS" ]; then
                    ROFI_OPTIONS="$TITLE"
                else
                    ROFI_OPTIONS="$ROFI_OPTIONS"$'\n'"$TITLE"
                fi
                STYLE_MAP["$TITLE"]="$style_subdir"
            fi
        fi
    }

    process_dir "$DEFAULT_STYLE"

    for style_subdir in $(ls "$STYLE_DIR/"); do
        if [ "$style_subdir" != "$DEFAULT_STYLE" ]; then
            process_dir "$style_subdir"
        fi
    done

    SELECTION=$(echo "$ROFI_OPTIONS" | rofi -dmenu -i -p "Choose LXDE Openbox Style")

    if [ -z "$SELECTION" ]; then
        exit 0
    fi

    STYLE_SUBDIR="${STYLE_MAP[$SELECTION]}"

    if [ -z "$STYLE_SUBDIR" ]; then
        notify-send "$SCRIPT_NAME" "Error: Invalid input!"
        exit 1
    fi
fi

SRC_LX_DESKTOP_CONF="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/desktop.conf"
SRC_LX_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/autostart"
SRC_OB_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/autostart"
SRC_OB_RC="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/rc.xml"

SRC_START_MENU="$STYLE_DIR/$STYLE_SUBDIR/rofi-config-windows-start-menu.rasi"
SRC_TASKBAR="$STYLE_DIR/$STYLE_SUBDIR/plank.ini"
SRC_BOTTOM_PANEL_MENU="$STYLE_DIR/$STYLE_SUBDIR/tint2-bottom-panel-menu"
SRC_BOTTOM_UPPER_PANEL="$STYLE_DIR/$STYLE_SUBDIR/tint2-bottom-upper-panel"
SRC_BOTTOM_PANEL="$STYLE_DIR/$STYLE_SUBDIR/tint2-bottom-panel"
SRC_TOP_BAR="$STYLE_DIR/$STYLE_SUBDIR/tint2-top-bar"

ln -sf "$SRC_LX_DESKTOP_CONF" "$LX_DESKTOP_CONF"
ln -sf "$SRC_LX_AUTOSTART" "$LX_AUTOSTART"
ln -sf "$SRC_OB_AUTOSTART" "$OB_AUTOSTART"
ln -sf "$SRC_OB_RC" "$LX_RC"
ln -sf "$SRC_OB_RC" "$OB_RC"

ln -sf "$SRC_START_MENU" "$START_MENU"
ln -sf "$SRC_TASKBAR" "$TASKBAR"
ln -sf "$SRC_BOTTOM_PANEL_MENU" "$BOTTOM_PANEL_MENU"
ln -sf "$SRC_BOTTOM_UPPER_PANEL" "$BOTTOM_UPPER_PANEL"
ln -sf "$SRC_BOTTOM_PANEL" "$BOTTOM_PANEL"
ln -sf "$SRC_TOP_BAR" "$TOP_BAR"

ln -sf "$STYLE_DIR/$STYLE_SUBDIR/start-desktop.sh" "$HOME/.config/openbox/start-desktop.sh"

case 0 in
    $(pgrep -x "lxsession" >/dev/null; echo $?))
        ;;
    $(pgrep -x "openbox" >/dev/null; echo $?))
        ;;
    *)
        exit 0
        ;;
esac

notify-send "$SCRIPT_NAME" "$SELECTION applied"
