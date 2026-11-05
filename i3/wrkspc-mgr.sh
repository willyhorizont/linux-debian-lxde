#!/bin/bash

SCRIPT_NAME="wrkspc-mgr.sh"

if ! command -v xdotool >/dev/null 2>&1 || ! command -v wmctrl >/dev/null 2>&1 || ! command -v xprop >/dev/null 2>&1; then
    notify-send "[$SCRIPT_NAME]" "Error: missing dependencies 'xdotool wmctrl xprop'..."
    exit 1
fi

PROCESSED=0
MOV_WIN_MODE=false
TRGT_WIN_ID=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --goto)
            PROCESSED=1
            shift
            ;;
        --mov)
            MOV_WIN_MODE=true
            TRGT_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
            if [ -z "$TRGT_WIN_ID" ]; then
                notify-send "[$SCRIPT_NAME]" "Error: active window not found!"
                exit 1
            fi
            PROCESSED=1
            shift
            ;;
        --plus)
            TRGT_WRKSPC=$(i3-msg -t get_workspaces | jq '[.[].num] | max + 1')
            PROCESSED=1
            shift
            ;;
        *)
            echo "Usage: $0 [--goto] [--mov] [--plus]"
            exit 1
            ;;
    esac
done

if [ -z "$TRGT_WRKSPC" ]; then
    PROCESSED=0
fi

if [ $PROCESSED -eq 0 ]; then
    ROFI_LIST=$(xprop -root _NET_DESKTOP_NAMES 2>/dev/null | awk -F'"' '{for(i=2; i<=NF; i+=2) print $i}' | tr '\n' '\\' | sed 's/\\/\\n/g' | sed 's/\\n$//')
    if [ "$MOV_WIN_MODE" = true ]; then
        FULL_NM=$(xdotool getwindowname "$TRGT_WIN_ID" 2>/dev/null)
        if [ ${#FULL_NM} -gt 43 ]; then
            WIN_NM="${FULL_NM:0:20}...${FULL_NM: -20}"
        else
            WIN_NM="$FULL_NM"
        fi
        WM_CLASS=$(xprop -id "$TRGT_WIN_ID" WM_CLASS 2>/dev/null | awk -F'"' '{print $4}')
        if [ -n "$WM_CLASS" ]; then
            WIN_NM="$WM_CLASS | $WIN_NM"
        fi
        PROMPT_MSG="Move [$WIN_NM] to Workspace"
    else
        PROMPT_MSG="Go to Workspace"
    fi
    ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG")
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
        i3-msg move container to workspace "$TRGT_WRKSPC"
    fi
    i3-msg workspace "$TRGT_WRKSPC"
else
    notify-send "[$SCRIPT_NAME]" "Error: invalid input!"
fi
