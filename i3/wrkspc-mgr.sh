#!/bin/bash

SCRIPT_NAME="wrkspc-mgr.sh"

if ! command -v xdotool >/dev/null 2>&1 || ! command -v wmctrl >/dev/null 2>&1 || ! command -v xprop >/dev/null 2>&1; then
    notify-send "[$SCRIPT_NAME]" "Error: missing dependencies 'xdotool wmctrl xprop'..."
    exit 1
fi

PROCESSED=0
MODE_SELECTED=false
MOV_WIN_MODE=false
TRGT_WIN_ID=""
WIN_DATA=""
WIN_NM=""
WIN_META=""
FULL_NM=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --goto)
            MODE_SELECTED=true
            PROCESSED=1
            shift
            ;;
        --mov)
            MODE_SELECTED=true
            MOV_WIN_MODE=true
            WIN_DATA=$("$HOME/willyhorizont.github.io/linux/rofi-windows-task-view-mac-mission-control.sh" --print --title 'Choose Window to Move')
            TRGT_WIN_ID=$(echo "$WIN_DATA" | awk '{print $1}')
            if [ -z "$TRGT_WIN_ID" ]; then
                exit 0
            fi
            WIN_META=$(echo "$WIN_DATA" | awk '{print $1 " " $3}')
            FULL_NM=$(echo "$WIN_DATA" | awk '{$1=$2=$3=""; sub(/^[ \t]+/, ""); print}')
            PROCESSED=1
            shift
            ;;
        --mov-cur-win)
            MODE_SELECTED=true
            MOV_WIN_MODE=true
            TRGT_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
            if [ -z "$TRGT_WIN_ID" ]; then
                notify-send "[$SCRIPT_NAME]" "Error: active window not found!"
                exit 1
            fi
            TRGT_WIN_ID_HEX=$(printf "0x%08x" "$TRGT_WIN_ID" 2>/dev/null)
            WIN_DATA=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh" | awk -v wid="$TRGT_WIN_ID" -v widhex="$TRGT_WIN_ID_HEX" 'tolower($1) == tolower(wid) || tolower($1) == tolower(widhex) {print $0}')
            WIN_META=$(echo "$WIN_DATA" | awk '{print $1 " " $7}')
            FULL_NM=$(echo "$WIN_DATA" | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; sub(/^[ \t]+/, ""); print}')
            PROCESSED=1
            shift
            ;;
        --plus)
            TRGT_WRKSPC=$(i3-msg -t get_workspaces | jq '[.[].num] | max + 1')
            PROCESSED=1
            shift
            ;;
        --prev)
            i3-msg workspace prev
            exit 0
            ;;
        --next)
            i3-msg workspace next
            exit 0
            ;;
        --number)
            TRGT_WRKSPC=$2
            PROCESSED=1
            shift 2
            ;;
        *)
            echo "Usage: $0 [--goto] [--mov] [--mov-cur-win] [--plus] [--prev] [--next] [--number workspace_number]"
            exit 1
            ;;
    esac
done

if [ -z "$TRGT_WRKSPC" ]; then
    PROCESSED=0
fi

if [ -z "$WIN_META" ] && [ -z "$FULL_NM" ]; then
    TRGT_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
    TRGT_WIN_ID_HEX=$(printf "0x%08x" "$TRGT_WIN_ID" 2>/dev/null)
    WIN_DATA=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh" | awk -v wid="$TRGT_WIN_ID" -v widhex="$TRGT_WIN_ID_HEX" 'tolower($1) == tolower(wid) || tolower($1) == tolower(widhex) {print $0}')
    WIN_META=$(echo "$WIN_DATA" | awk '{print $1 " " $7}')
    FULL_NM=$(echo "$WIN_DATA" | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; sub(/^[ \t]+/, ""); print}')
fi

if [ -z "$WIN_NM" ]; then
    if [ ${#FULL_NM} -gt 43 ]; then
        SHORT_NM="${FULL_NM:0:20}...${FULL_NM: -20}"
    else
        SHORT_NM="$FULL_NM"
    fi
    WIN_NM="$WIN_META $SHORT_NM"
    WIN_NM="[${WIN_NM}]"
fi

MAIN_MENU_OPTIONS=(
    "Go to Workspace"
    "Move Window to Workspace"
    "Move $WIN_NM to Workspace"
    "New Workspace"
    "Next Workspace"
    "Previous Workspace"
)

if [ $PROCESSED -eq 0 ] && [ "$MODE_SELECTED" = false ]; then
    MAIN_MENU_CHOICE=$(printf "%s\n" "${MAIN_MENU_OPTIONS[@]}" | rofi -dmenu -p "$SCRIPT_NAME" -theme-str 'window { width: 90%; }')
    case "$MAIN_MENU_CHOICE" in
        "${MAIN_MENU_OPTIONS[0]}")
            exec "$0" --goto
            ;;
        "${MAIN_MENU_OPTIONS[1]}")
            exec "$0" --mov
            ;;
        "${MAIN_MENU_OPTIONS[2]}")
            exec "$0" --mov-cur-win
            ;;
        "${MAIN_MENU_OPTIONS[3]}")
            exec "$0" --plus
            ;;
        "${MAIN_MENU_OPTIONS[4]}")
            exec "$0" --next
            ;;
        "${MAIN_MENU_OPTIONS[5]}")
            exec "$0" --prev
            ;;
        *)
            exit 0
            ;;
    esac
fi

if [ $PROCESSED -eq 0 ]; then
    ROFI_LIST=$(xprop -root _NET_DESKTOP_NAMES 2>/dev/null | awk -F'"' '{for(i=2; i<=NF; i+=2) print $i}' | tr '\n' '\\' | sed 's/\\/\\n/g' | sed 's/\\n$//')
    if [ "$MOV_WIN_MODE" = true ]; then
        PROMPT_MSG="Move $WIN_NM to Workspace"
        ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG" -theme-str 'window { width: 90%; }')
    else
        PROMPT_MSG="Go to Workspace"
        ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG")
    fi
    if [ -z "$ROFI_INPUT" ]; then
        exit 0
    fi
    TRGT_WRKSPC="$ROFI_INPUT"
fi

if [ -z "$TRGT_WRKSPC" ]; then
    exit 0
fi

if echo "$TRGT_WRKSPC" | grep -qE '^[0-9]+$'; then
    if [ "$MOV_WIN_MODE" = true ]; then
        i3-msg "[id="$TRGT_WIN_ID"] move container to workspace number $TRGT_WRKSPC"
    fi
    i3-msg workspace "$TRGT_WRKSPC"
else
    notify-send "[$SCRIPT_NAME]" "Error: invalid input!"
fi
