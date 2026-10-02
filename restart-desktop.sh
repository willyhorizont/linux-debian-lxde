#!/bin/sh

notify-send "Restarting Desktop..."

openbox --reconfigure

killall -9 tint2 plank

xdotool search --class "tint2" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null
xdotool search --class "plank" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null

nohup ~/willyhorizont.github.io/linux-debian-lxde/start-desktop.sh >/dev/null 2>&1 &
