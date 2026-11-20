#!/bin/bash

SCRIPT_NAME="rofi-windows-taskbar-mac-dock.sh"
YOFFSET=36
XOFFSET=$((YOFFSET + 1))

INVERT_MODE=false
INDICATOR_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --invert)
            INVERT_MODE=true
            shift
        ;;
        --indicator)
            INDICATOR_MODE=true
            shift
        ;;
        --number)
            APP_ORDER="$2"
            shift 2
        ;;
        --yoffset)
            YOFFSET="$2"
            shift 2
        ;;
        --xoffset)
            XOFFSET="$2"
            shift 2
        ;;
        *)                                            shift ;;
    esac
done

ARG1="$1"
ARG2="$2"

if [ "$INVERT_MODE" = true ]; then
    INVERT_MODE=true
    FILE_NAME="rofi-windows-task-view-mac-mission-control.sh"
else
    if [ -z "$APP_ORDER" ]; then
        notify-send "[$SCRIPT_NAME]" "Usage: $SCRIPT_NAME [--number fav-app-order] [--invert] [--indicator]"
        exit 1
    fi

    case "$APP_ORDER" in
        1) FILE_NAME="lxterminal" ;;
        2) FILE_NAME="pcmanfm" ;;
        3) FILE_NAME="firefox-esr" ;;
        4) FILE_NAME="brave-browser" ;;
        5) FILE_NAME="vivaldi-stable" ;;
        6) FILE_NAME="chromium" ;;
        7) FILE_NAME="com.microsoft.VSCode" ;;
    esac
fi

declare -A APP_WM_CLASS
APP_WM_CLASS["lxterminal"]="Lxterminal"
APP_WM_CLASS["pcmanfm"]="Pcmanfm"
APP_WM_CLASS["firefox-esr"]="firefox-esr"
APP_WM_CLASS["brave-browser"]="Brave-browser"
APP_WM_CLASS["vivaldi-stable"]="Vivaldi-stable"
APP_WM_CLASS["chromium"]="Chromium"
APP_WM_CLASS["com.microsoft.VSCode"]="VSCode"
APP_WM_CLASS["rofi-windows-task-view-mac-mission-control.sh"]="rofi-windows-task-view-mac-mission-control.sh"

declare -A APP_ICON
APP_ICON["lxterminal"]="lxterminal"
APP_ICON["pcmanfm"]="system-file-manager"
APP_ICON["firefox-esr"]="firefox-esr"
APP_ICON["brave-browser"]="brave-browser"
APP_ICON["vivaldi-stable"]="vivaldi"
APP_ICON["chromium"]="chromium"
APP_ICON["com.microsoft.VSCode"]="vscode"
# APP_ICON["rofi-windows-task-view-mac-mission-control.sh"]="preferences-system-windows"
# APP_ICON["rofi-windows-task-view-mac-mission-control.sh"]="view-pages-overview"
APP_ICON["rofi-windows-task-view-mac-mission-control.sh"]="workspace-switcher"
# APP_ICON["rofi-windows-task-view-mac-mission-control.sh"]="virtual-desktops"
# APP_ICON["rofi-windows-task-view-mac-mission-control.sh"]="window-duplicate"

declare -A APP_TOOLTIP
APP_TOOLTIP["lxterminal"]="Terminal Emulator"
APP_TOOLTIP["pcmanfm"]="File Manager"
APP_TOOLTIP["firefox-esr"]="Firefox Web Browser"
APP_TOOLTIP["brave-browser"]="Brave Web Browser"
APP_TOOLTIP["vivaldi-stable"]="Vivaldi Web Browser"
APP_TOOLTIP["chromium"]="Chromium Web Browser"
APP_TOOLTIP["com.microsoft.VSCode"]="Visual Studio Code"
APP_TOOLTIP["rofi-windows-task-view-mac-mission-control.sh"]="rofi Windows Task View / Mac Mission Control"

GET_OPEN_WINS_SCRIPT="$HOME/willyhorizont.github.io/linux/get-open-wins.sh"

if [ ! -f "$GET_OPEN_WINS_SCRIPT" ]; then
    notify-send "[$SCRIPT_NAME]" "Error: $GET_OPEN_WINS_SCRIPT not found."
    exit 1
fi

WM_CLASS="${APP_WM_CLASS[$FILE_NAME]}"
if [ -z "$WM_CLASS" ]; then
    WM_CLASS="$FILE_NAME"
fi

FAV_CLASSES_REGEX=""
for k in "${!APP_WM_CLASS[@]}"; do
    if [ "$k" != "rofi-windows-task-view-mac-mission-control.sh" ]; then
        FAV_CLASSES_REGEX+="${APP_WM_CLASS[$k]}|"
    fi
done
FAV_CLASSES_REGEX="^(${FAV_CLASSES_REGEX%|})$"

get_wids() {
    "$GET_OPEN_WINS_SCRIPT" | awk -v invert_mode="$INVERT_MODE" -v fav_regex="$FAV_CLASSES_REGEX" -v tgt_wm_class="$WM_CLASS" '
    {
        if ($2 == -1) next;
        wm_classname_class = split($7, wm_class_parts, ".");
        wm_class_nu = (wm_classname_class > 0) ? wm_class_parts[wm_classname_class] : $7;
        if (invert_mode == "true") {
            if (tolower(wm_class_nu) !~ tolower(fav_regex)) {
                print $1
            }
        } else {
            if (tolower(wm_class_nu) == tolower(tgt_wm_class)) {
                print $1
            }
        }
    }'
}

if [ "$INDICATOR_MODE" = false ]; then
    if [ "$INVERT_MODE" = true ]; then
        exit 0
    fi
    WIDS=$(get_wids)
    WID_COUNT=$(echo "$WIDS" | grep -c .)

    if [ "$WID_COUNT" -eq 0 ]; then
        coproc (gtk-launch "$FILE_NAME" > /dev/null 2>&1 || "$FILE_NAME" > /dev/null 2>&1)
        exit 0
    fi

    if [ "$WID_COUNT" -eq 1 ]; then
        xdotool windowactivate "$(echo "$WIDS" | tr -d '\n')" 2>/dev/null
        exit 0
    fi

    WINS_RAW=$("$GET_OPEN_WINS_SCRIPT")
    DESKTOP_NAMES=$(xprop -root _NET_DESKTOP_NAMES 2>/dev/null | awk -F'"' '{for(i=2; i<=NF; i+=2) print $i}')

    ROFI_LIST=$(echo "$WINS_RAW" | awk -v names_str="$DESKTOP_NAMES" -v tgt_class="$WM_CLASS" '
        BEGIN {
            split(names_str, names_arr, "\n");
        }
        {
            if ($2 == -1) next;
            wm_classname_class = split($7, wm_class_parts, ".");
            wm_class_nu = (wm_classname_class > 0) ? wm_class_parts[wm_classname_class] : $7;
            if (tolower(wm_class_nu) != tolower(tgt_class)) next;
            ws_name = names_arr[$2 + 1];
            if (ws_name == "") ws_name = $2;
            gsub(/[^0-9]/, "", ws_name);
            window_title = "";
            for(i=9; i<=NF; i++) {
                window_title = (window_title == "" ? $i : window_title " " $i);
            }
            lines[NR] = $1 " " ws_name " " window_title
            wm_classes[NR] = $7
            if (length($7) > max_7) {
                max_7 = length($7)
            }
        }
        END {
            for (j = 1; j <= NR; j++) {
                if (!lines[j]) continue;
                split(lines[j], parts, " ");
                win_id = parts[1];
                ws = parts[2];
                match(lines[j], /([^ \t]+[ \t]+){2}/)
                title = substr(lines[j], RSTART + RLENGTH)
                fmt = sprintf("%%s    %%s    %%-%ds    %%s\n", max_7)
                printf fmt, win_id, ws, wm_classes[j], title
            }
        }
    ' | sort -V -k2)

    if [ -z "$ROFI_LIST" ]; then
        exit 0
    fi

    ROFI_THEME="
        configuration { location: 7; anchor: 7; yoffset: -${YOFFSET}; xoffset: ${XOFFSET}; }
        window { width: 90%; }
    "

    ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -i -p "[$SCRIPT_NAME] Switch between [$FILE_NAME] windows" -theme-str "$ROFI_THEME")

    if [ -z "$ROFI_INPUT" ]; then
        exit 0
    fi

    TRGT_WIN_ID=$(echo "$ROFI_INPUT" | awk '{print $1}')

    if [ -n "$TRGT_WIN_ID" ]; then
        xdotool windowactivate "$TRGT_WIN_ID" 2>/dev/null
    fi

    exit 0
fi

ICON_BASE_NAME="${APP_ICON[$FILE_NAME]}"
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

if [ -z "$ICON_PATH" ]; then
    ICON_PATH="/usr/share/icons/hicolor/scalable/apps/application-x-desktop.svg"
fi

WID_COUNT=$(get_wids | grep -c .)
if [ "$WID_COUNT" -gt 0 ]; then
    INDICATOR="<span background='#FFFFFF' foreground='#FF1493'>+</span>]"
else
    INDICATOR="<span background='#FFFFFF' foreground='#00ADD8'>0</span>]"
fi
printf "%s\n%s\n" "$ICON_PATH" "$INDICATOR"
if [ "$INVERT_MODE" = true ]; then
    TOOLTIP_TXT=$(cat << EOF
rofi-windows-task-view-mac-mission-control.sh
[other opened wins] x $WID_COUNT
click to open rofi-windows-task-view-mac-mission-control.sh;
EOF
    )
    printf "\e[2J%s" "$TOOLTIP_TXT" 1>&2
else
    TOOLTIP_TXT=$(cat << EOF
rofi-windows-taskbar-mac-dock.sh
[${APP_TOOLTIP[$FILE_NAME]}] x $WID_COUNT
EOF
    )
    printf "\e[2J%s\n" "$TOOLTIP_TXT" 1>&2
fi
LAST_WID_COUNT="$WID_COUNT"

xprop -root -spy _NET_CLIENT_LIST | while read -r line; do
    WID_COUNT=$(get_wids | grep -c .)
    if [ "$WID_COUNT" != "$LAST_WID_COUNT" ]; then
        if [ "$WID_COUNT" -gt 0 ]; then
            INDICATOR="<span background='#FFFFFF' foreground='#FF1493'>+</span>]"
        else
            INDICATOR="<span background='#FFFFFF' foreground='#00ADD8'>0</span>]"
        fi
        printf "%s\n%s\n" "$ICON_PATH" "$INDICATOR"
        if [ "$INVERT_MODE" = true ]; then
            TOOLTIP_TXT=$(cat << EOF
rofi-windows-task-view-mac-mission-control.sh
[other opened wins] x $WID_COUNT
click to open rofi-windows-task-view-mac-mission-control.sh;
EOF
            )
            printf "\e[2J%s" "$TOOLTIP_TXT" 1>&2
        else
            TOOLTIP_TXT=$(cat << EOF
rofi-windows-taskbar-mac-dock.sh
[${APP_TOOLTIP[$FILE_NAME]}] x $WID_COUNT
EOF
            )
            printf "\e[2J%s\n" "$TOOLTIP_TXT" 1>&2
        fi
        LAST_WID_COUNT="$WID_COUNT"
    fi
done
