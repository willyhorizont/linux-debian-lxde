#!/bin/bash

TARGET_DIR="$HOME/willyhorizont.gitbub.io"
mkdir -p "$TARGET_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TARGET_FILE="$TARGET_DIR/CUR_ACTV_WIN_CLASS_${TIMESTAMP}.txt"

CUR_ACTV_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
CUR_ACTV_WIN_CLASS=$(xprop -id "$CUR_ACTV_WIN_ID" 2>/dev/null)
IS_IN_DESKTOP=false
IS_SHOWING_DESKTOP_STATE=$(xprop -root _NET_SHOWING_DESKTOP 2>/dev/null | awk '{print $3}')
if [ "$IS_SHOWING_DESKTOP_STATE" = "1" ]; then
    IS_IN_DESKTOP=true
fi

TOOLTIP_TXT="
CUR_ACTV_WIN_ID: $CUR_ACTV_WIN_ID
IS_IN_DESKTOP:
$IS_IN_DESKTOP
"

# printf "%s" "$TOOLTIP_TXT" > "$TARGET_FILE"

echo "</>"
printf "%s" "$TOOLTIP_TXT" 1>&2
