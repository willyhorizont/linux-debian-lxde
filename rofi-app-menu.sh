#!/bin/sh

env XDG_CURRENT_DESKTOP="$DESKTOP_SESSION"
yoffset=36
width_in_px=360

while [ $# -gt 0 ]; do
    case "$1" in
        --spotlight)
            rofi -modi "Apps:$HOME/willyhorizont.github.io/linux-debian-lxde/rofi-manage-apps.sh" -show Apps
            exit 0
        ;;
        --yoffset)           yoffset="$2";            shift 2 ;;
        --width-in-px)       width_in_px="$2";        shift 2 ;;
        *)                                            shift ;;
    esac
done

rofi -modi "Apps:$HOME/willyhorizont.github.io/linux-debian-lxde/rofi-manage-apps.sh" -show Apps -theme-str "configuration { location: 7; anchor: 7; yoffset: -${yoffset}; xoffset: 0; } window { width: ${width_in_px}px; }"
