#!/bin/bash

cur_actv_wid_hex=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{print $NF}')
caja_wid_hex=$(wmctrl -l -x -G 2>/dev/null | awk '$7 == "desktop_window.Caja" && $9 == "Desktop" {print $1}')

if false ||
    { [ -n "$caja_wid_hex" ] && [ "$cur_actv_wid_hex" = "$caja_wid_hex" ]; } ||
    xprop -root _NET_SHOWING_DESKTOP 2>/dev/null | grep -q "= 1" ||
    xprop -id "$cur_actv_wid_hex" _NET_WM_WINDOW_TYPE 2>/dev/null | grep -q "_NET_WM_WINDOW_TYPE_DESKTOP" ||
    false; then
    xdotool key ctrl+super+d
fi
