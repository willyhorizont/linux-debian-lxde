#!/bin/bash

SCRIPT_NAME="wrkspc-mgr.sh"

if ! command -v xdotool >/dev/null 2>&1 || ! command -v wmctrl >/dev/null 2>&1 || ! command -v xprop >/dev/null 2>&1; then
    notify-send "[$SCRIPT_NAME]" "Error: missing dependencies 'xdotool wmctrl xprop'..."
    exit 1
fi

MOV_WIN_MODE=false
TRGT_WIN_ID=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --mov)
            MOV_WIN_MODE=true
            TRGT_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
            if [ -z "$TRGT_WIN_ID" ]; then
                notify-send "[$SCRIPT_NAME]" "Error: active window not found!"
                exit 1
            fi
            shift
            ;;
        *)
            echo "Usage: $0 [--mov]"
            exit 1
            ;;
    esac
done

ROFI_LIST=$(wmctrl -d | awk '{print $9}')

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

if [ "$MOV_WIN_MODE" = true ]; then
    i3-msg move container to workspace "$ROFI_INPUT"
fi

i3-msg workspace "$ROFI_INPUT"
