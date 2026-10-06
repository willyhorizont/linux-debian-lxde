#!/bin/sh

notify-send "Restarting Desktop..."

pkill -f "$HOME/willyhorizont.github.io/linux/start-desktop.sh" 2>/dev/null
pkill -f "$HOME/willyhorizont.github.io/linux/lockerd.sh" 2>/dev/null
pkill -x "xterm"
pkill -x "xpenguins"

openbox --reconfigure

killall -9 tint2 plank 2>/dev/null

xdotool search --name "tint2-bottom-panel" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null
xdotool search --name "tint2-top-bar" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null
xdotool search --class "plank" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null

nohup bash -c "$HOME/willyhorizont.github.io/linux-debian-lxde/start-desktop.sh" >/dev/null 2>&1 &
