#!/bin/bash

LOCK_FILE="/tmp/i3-toggle-show-desktop.lock"
exec 200>"$LOCK_FILE"
flock -n 200 || exit 1

STAT_FILE="/tmp/i3-lst-actv-ws-b4-togl-shw-dsktp.state"

CUR_WS_I=$(xdotool get_desktop 2>/dev/null)
CUR_WS_WIDS=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh" | awk -v ws="$CUR_WS_I" '$2 == ws {print $1}')

if [ -z "$CUR_WS_WIDS" ]; then
    if [ -f "$STAT_FILE" ]; then
        LST_WS=$(cat "$STAT_FILE")
        if [ -n "$LST_WS" ]; then
            i3-msg workspace "$LST_WS"
        else
            "$HOME/willyhorizont.github.io/linux-debian-lxde/wrkspc-mgr.sh" --prev --i3-mode
        fi
    else
        "$HOME/willyhorizont.github.io/linux-debian-lxde/wrkspc-mgr.sh" --prev --i3-mode
    fi
else
    CUR_WS_NM=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
    echo "$CUR_WS_NM" > "$STAT_FILE"
    WS_NM_NU=$(i3-msg -t get_workspaces | jq '[.[].num] | max + 1')
    i3-msg workspace "$WS_NM_NU"
fi
