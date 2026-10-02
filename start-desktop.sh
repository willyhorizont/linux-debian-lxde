#!/bin/sh

plank &
xdotool search --sync --onlyvisible --class "plank" >/dev/null 2>&1
tint2 -c ~/willyhorizont.github.io/linux-debian-lxde/tint2-top-bar &
tint2 -c ~/willyhorizont.github.io/linux-debian-lxde/tint2-bottom-panel &
xdotool search --sync --onlyvisible --class "tint2" >/dev/null 2>&1
~/willyhorizont.github.io/linux/tuxd.sh &
