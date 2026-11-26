#!/bin/bash

export XDG_CURRENT_DESKTOP="$DESKTOP_SESSION"

SCRIPT_NAME="rofi-windows-start-menu-mac-launchpad.sh"
YOFFSET=32
WIDTH_IN_PX=360
INDICATOR_MODE=false
SPOTLIGHT_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --indicator)
            INDICATOR_MODE=true
            shift
        ;;
        --spotlight)
            SPOTLIGHT_MODE=true
            shift
        ;;
        --yoffset)
            YOFFSET="$2"
            shift 2
        ;;
        --width-in-px)
            WIDTH_IN_PX="$2"
            shift 2
        ;;
        *)
            shift
        ;;
    esac
done

if [ "$INDICATOR_MODE" = false ] && [ "$SPOTLIGHT_MODE" = false ] && command -v xfce4-popup-whiskermenu >/dev/null 2>&1; then
    xfce4-popup-whiskermenu >/dev/null 2>&1 && exit 0
fi

if [ "$SPOTLIGHT_MODE" = true ]; then
    rofi -modi "All Apps:$HOME/willyhorizont.github.io/linux-debian-lxde/rofi-manage-apps.sh" -show "All Apps" -theme-str "promptbox { children: [ textbox-title ]; } textbox-title { background-color: transparent; text-color: #FF1493; str: \"$SCRIPT_NAME\"; padding: 0px; margin: 2px 8px 0px 8px; }"
    exit 0
fi

if [ "$INDICATOR_MODE" = true ]; then
    ICON_BASE_NAME="distributor-logo-debian"
    ICON_PATH=$(find /usr/share/icons/Papirus /usr/share/icons/Papirus-Light /usr/share/icons/Papirus-Dark /usr/share/icons /usr/share/pixmaps "$HOME/.local/share/icons" -name "${ICON_BASE_NAME}.png" -o -name "${ICON_BASE_NAME}.svg" 2>/dev/null | awk '
    {
        if ($0 ~ /scalable/) {
            size = 9999
        } else {
            match($0, /[0-9]+x[0-9]+/)
            if (RSTART > 0) {
                split(substr($0, RSTART, RLENGTH), parts, "x")
                size = parts[1]
            } else {
                size = 0
            }
        }
        if (tolower($0) ~ /papirus/) {
            priority = 100000 + size
        } else {
            priority = size
        }
        print priority, $0
    }' | sort -nr -k1 | awk '{print $2}' | head -n 1)

    [ -z "$ICON_PATH" ] && ICON_PATH="/usr/share/icons/hicolor/scalable/apps/application-x-desktop.svg"

    printf "%s\n\n" "$ICON_PATH"
    TOOLTIP_TXT=$(cat << EOF
$SCRIPT_NAME
EOF
    )
    printf "\e[2J%s\n" "$TOOLTIP_TXT" 1>&2
    exit 0
fi

rofi -modi "All Apps:$HOME/willyhorizont.github.io/linux-debian-lxde/rofi-manage-apps.sh,Exit ⏻:$HOME/willyhorizont.github.io/linux-debian-lxde/rofi-manage-apps.sh --exit-mode" -show "All Apps" -theme-str "configuration { location: 7; anchor: 7; yoffset: -${YOFFSET}; xoffset: 0; } window { width: ${WIDTH_IN_PX}px; } promptbox { children: [ textbox-title ]; } textbox-title { background-color: transparent; text-color: #FF1493; str: \"$SCRIPT_NAME\"; padding: 0px; margin: 2px 8px 0px 8px; } mainbox { children: [ inputbar, listview, mode-switcher ]; }"
