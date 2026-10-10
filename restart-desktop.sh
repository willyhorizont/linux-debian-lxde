#!/bin/sh

notify-send "Restarting Desktop..."

openbox --reconfigure

pkill -9 -f "$HOME/willyhorizont.github.io/linux-debian-lxde/start-desktop.sh" 2>/dev/null
pkill -9 -f "$HOME/willyhorizont.github.io/linux/blu-lght-fltr.sh" 2>/dev/null
pkill -9 -f "$HOME/willyhorizont.github.io/linux/lockerd.sh" 2>/dev/null

pkill -9 -f "xterm.*-name idle-window" 2>/dev/null
pkill -9 -f "xterm.*-name welcome-window" 2>/dev/null

pkill -9 -x "xpenguins" 2>/dev/null

pkill -9 -f "tint2 -c .*tint2-top-bar" 2>/dev/null
pkill -9 -f "tint2 -c .*tint2-bottom-panel" 2>/dev/null

xdotool search --name "tint2-bottom-panel" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null
xdotool search --name "tint2-top-bar" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null

killall -9 plank 2>/dev/null

xdotool search --class "plank" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null

setsid bash -c "$HOME/willyhorizont.github.io/linux-debian-lxde/start-desktop.sh" >/dev/null 2>&1 &
