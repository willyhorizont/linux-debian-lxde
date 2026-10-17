#!/bin/sh

(until pactl info >/dev/null 2>&1; do true; done && pactl set-source-mute @DEFAULT_SOURCE@ 1) >/dev/null 2>&1 &

# plank &
# xdotool search --sync --onlyvisible --class "plank" >/dev/null 2>&1

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-bottom-panel-i3" &
xdotool search --sync --onlyvisible --name "tint2-bottom-panel-i3" >/dev/null 2>&1

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-top-bar" &
xdotool search --sync --onlyvisible --name "tint2-top-bar" >/dev/null 2>&1

# setsid bash -c "$HOME/willyhorizont.github.io/linux/dmn-lockr.sh --shw-tux false --shw-win false" >/dev/null 2>&1 &
