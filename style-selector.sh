#!/bin/bash

SCRIPT_NAME="style-selector.sh"

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

LX_DESKTOP_CONF="$HOME/.config/lxsession/LXDE/desktop.conf"
LX_AUTOSTART="$HOME/.config/lxsession/LXDE/autostart"
LX_RC="$HOME/.config/openbox/lxde-rc.xml"
OB_AUTOSTART="$HOME/.config/openbox/autostart"
OB_RC="$HOME/.config/openbox/rc.xml"

mkdir -p "$HOME/.config/lxsession/LXDE"
mkdir -p "$HOME/.config/openbox"

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

SRC_LX_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/autostart"
SRC_LX_DESKTOP_CONF="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/desktop.conf"
SRC_OB_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/autostart"
SRC_OB_RC="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/rc.xml"

ln -sf "$SRC_LX_DESKTOP_CONF" "$LX_DESKTOP_CONF"
ln -sf "$SRC_LX_AUTOSTART" "$LX_AUTOSTART"
ln -sf "$SRC_OB_RC" "$LX_RC"
ln -sf "$SRC_OB_AUTOSTART" "$OB_AUTOSTART"
ln -sf "$SRC_OB_RC" "$OB_RC"

bash -c "$HOME/.config/openbox/start-desktop.sh --kill" >/dev/null 2>&1
ln -sf "$STYLE_DIR/$STYLE_SUBDIR/start-desktop.sh" "$HOME/.config/openbox/start-desktop.sh"
bash -c "$HOME/.config/openbox/start-desktop.sh" >/dev/null 2>&1 &

notify-send "$SCRIPT_NAME" "$SELECTION chosen"
