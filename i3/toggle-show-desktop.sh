#!/bin/bash

STAT_FILE="/tmp/i3-lst-actv-wrkspc-before-toggle-show-desktop.state"

# CUR_WRKSPC=$(wmctrl -d | awk '{if ($2 == "*") print $1}')
CUR_WRKSPC=$(xdotool get_desktop 2>/dev/null)
CUR_WRKSPC_OPEN_WINS_COUNT=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh" | awk -v cur_wrkspc="$CUR_WRKSPC" '
BEGIN {
    c = 0
}
{
    if ($2 == cur_wrkspc) {
        c++
    }
}
END {
    print c
}
')

if [ "$CUR_WRKSPC_OPEN_WINS_COUNT" -eq 0 ]; then
    if [ -f "$STAT_FILE" ]; then
        LST_WRKSPC=$(cat "$STAT_FILE")
        if [ -n "$LST_WRKSPC" ]; then
            i3-msg workspace "$LST_WRKSPC"
        else
            "$HOME/willyhorizont.github.io/linux-debian-lxde/i3/wrkspc-mgr.sh" --prev
        fi
    else
        "$HOME/willyhorizont.github.io/linux-debian-lxde/i3/wrkspc-mgr.sh" --prev
    fi
else
    CUR_WRKSPC_NAME=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
    echo "$CUR_WRKSPC_NAME" > "$STAT_FILE"
    NU_WRKSPC=$(i3-msg -t get_workspaces | jq '[.[].num] | max + 1')
    i3-msg workspace "$NU_WRKSPC"
fi
