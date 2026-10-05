#!/bin/sh

(until pactl info >/dev/null 2>&1; do true; done && pactl set-source-mute @DEFAULT_SOURCE@ 1) >/dev/null 2>&1 &

plank &
xdotool search --sync --onlyvisible --class "plank" >/dev/null 2>&1
tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-top-bar" &
tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-bottom-panel" &
xdotool search --sync --onlyvisible --name "tint2-top-bar" >/dev/null 2>&1
xdotool search --sync --onlyvisible --name "tint2-bottom-panel" >/dev/null 2>&1
xterm -geometry 88x24 -bg black -fg white -fa Monospace -fs 8 -bc -uc -hold -e fastfetch &
xdotool search --sync --onlyvisible --class "XTerm" >/dev/null 2>&1
nohup bash -c "$HOME/willyhorizont.github.io/linux/screenlockerd.sh" >/dev/null 2>&1 &
