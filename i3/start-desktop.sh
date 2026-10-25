#!/bin/bash

pkill -x polybar
pkill -x tint2

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/i3/tint2-top-bar" &
polybar i3switcher &

while true; do
    WID_TARGET=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "polybar.Polybar" && index($0, "polybar-i3switcher") {print $1}' 2>/dev/null)
    if [ -n "$WID_TARGET" ]; then
        break
    fi
    sleep 0.2
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/i3/tint2-bottom-panel" &
