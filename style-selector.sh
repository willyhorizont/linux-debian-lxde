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

I3_STYLE_DIR="$HOME/willyhorizont.github.io/linux-debian-lxde/i3/styles/"
STYLE_DIR="$HOME/willyhorizont.github.io/linux-debian-lxde/styles/"

get_style_subdir() {
    local target_style_dir="$1"
    local prompt_title="$2"
    local target_default_style_file="$target_style_dir/default.txt"
    local target_default_style
    target_default_style=$(cat "$target_default_style_file" 2>/dev/null | xargs)

    if [ -z "$target_default_style" ]; then
        notify-send "$SCRIPT_NAME" "Error: '$target_default_style_file' invalid!"
        exit 1
    fi

    if [ ! -d "$target_style_dir/$target_default_style" ]; then
        notify-send "$SCRIPT_NAME" "Error: directory '$target_style_dir/$target_default_style' not found!"
        exit 1
    fi

    if [ "$USE_DEFAULT" = true ]; then
        SELECTED_STYLE_SUBDIR="$target_default_style"
        local readme_file="$target_style_dir/$SELECTED_STYLE_SUBDIR/README.md"
        if [ -f "$readme_file" ]; then
            SELECTED_TITLE=$(head -n 1 "$readme_file" | sed 's/^#[[:space:]]*//' | xargs)
        fi
        if [ -z "$SELECTED_TITLE" ]; then
            SELECTED_TITLE="$target_default_style"
        fi
    else
        local rofi_options=""
        declare -A style_map

        process_dir() {
            local style_subdir="$1"
            local readme_file="$target_style_dir/$style_subdir/README.md"
            if [ -f "$readme_file" ]; then
                local title
                title=$(head -n 1 "$readme_file" | sed 's/^#[[:space:]]*//' | xargs)
                if [ -n "$title" ]; then
                    if [ -z "$rofi_options" ]; then
                        rofi_options="$title"
                    else
                        rofi_options="$rofi_options"$'\n'"$title"
                    fi
                    style_map["$title"]="$style_subdir"
                fi
            fi
        }

        process_dir "$target_default_style"

        for style_subdir in $(ls "$target_style_dir/"); do
            if [ "$style_subdir" != "$target_default_style" ]; then
                process_dir "$style_subdir"
            fi
        done

        SELECTED_TITLE=$(echo "$rofi_options" | rofi -dmenu -i -p "$prompt_title")

        if [ -z "$SELECTED_TITLE" ]; then
            exit 0
        fi

        SELECTED_STYLE_SUBDIR="${style_map[$SELECTED_TITLE]}"

        if [ -z "$SELECTED_STYLE_SUBDIR" ]; then
            notify-send "$SCRIPT_NAME" "Error: Invalid input!"
            exit 1
        fi
    fi
}

get_style_subdir "$STYLE_DIR" "Choose LXDE Openbox Style"
STYLE_SUBDIR="$SELECTED_STYLE_SUBDIR"
SELECTION="$SELECTED_TITLE"

get_style_subdir "$I3_STYLE_DIR" "Choose i3 Style"
I3_STYLE_SUBDIR="$SELECTED_STYLE_SUBDIR"
I3_SELECTION="$SELECTED_TITLE"

I3_CONF="$HOME/.config/i3/config"
LX_DESKTOP_CONF="$HOME/.config/lxsession/LXDE/desktop.conf"
LX_AUTOSTART="$HOME/.config/lxsession/LXDE/autostart"
LX_RC="$HOME/.config/openbox/lxde-rc.xml"
OB_AUTOSTART="$HOME/.config/openbox/autostart"
OB_RC="$HOME/.config/openbox/rc.xml"

BOTTOM_PANEL="$HOME/willyhorizont.github.io/.config/tint2-bottom-panel"
TOP_BAR="$HOME/willyhorizont.github.io/.config/tint2-top-bar"

SRC_I3_CONF="$I3_STYLE_DIR/$I3_STYLE_SUBDIR/.config/i3/config"
SRC_LX_DESKTOP_CONF="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/desktop.conf"
SRC_LX_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/lxsession/LXDE/autostart"
SRC_OB_AUTOSTART="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/autostart"
SRC_OB_RC="$STYLE_DIR/$STYLE_SUBDIR/.config/openbox/rc.xml"

SRC_BOTTOM_PANEL="$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-bottom-panel"
SRC_TOP_BAR="$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-top-bar"

ln -sf "$SRC_I3_CONF" "$I3_CONF"
ln -sf "$SRC_LX_DESKTOP_CONF" "$LX_DESKTOP_CONF"
ln -sf "$SRC_LX_AUTOSTART" "$LX_AUTOSTART"
ln -sf "$SRC_OB_AUTOSTART" "$OB_AUTOSTART"
ln -sf "$SRC_OB_RC" "$LX_RC"
ln -sf "$SRC_OB_RC" "$OB_RC"

ln -sf "$SRC_BOTTOM_PANEL" "$BOTTOM_PANEL"
ln -sf "$SRC_TOP_BAR" "$TOP_BAR"

ln -sf "$STYLE_DIR/$STYLE_SUBDIR/start-desktop.sh" "$HOME/.config/start-desktop.sh"

case "$DESKTOP_SESSION" in
    LXDE|openbox)
        notify-send "$SCRIPT_NAME" "$SELECTION applied"
        ;;
    i3)
        notify-send "$SCRIPT_NAME" "$I3_SELECTION applied"
        ;;
    *)
        echo "[$SCRIPT_NAME]" "Unsupported DESKTOP_SESSION: '$DESKTOP_SESSION'"
        exit 1
        ;;
esac
