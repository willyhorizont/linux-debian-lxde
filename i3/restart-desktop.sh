#!/bin/sh

notify-send "Restarting Desktop..."

i3-msg restart

pkill -9 -f "$HOME/willyhorizont.github.io/linux-debian-lxde/i3/start-desktop.sh" 2>/dev/null
pkill -9 -f "$HOME/willyhorizont.github.io/linux/blu-lght-fltr.sh" 2>/dev/null
pkill -9 -f "$HOME/willyhorizont.github.io/linux/lockerd.sh --shw-tux false --shw-win false" 2>/dev/null

pkill -9 -f "xterm.*-name idle-window" 2>/dev/null
pkill -9 -f "xterm.*-name welcome-window" 2>/dev/null

pkill -9 -x "xpenguins" 2>/dev/null

pkill -9 -f "tint2 -c .*tint2-top-bar" 2>/dev/null
xdotool search --name "tint2-top-bar" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null

pkill -9 -f "tint2 -c .*tint2-bottom-panel" 2>/dev/null
xdotool search --name "tint2-bottom-panel" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null

killall -9 plank 2>/dev/null
xdotool search --class "plank" 2>/dev/null | xargs -I {} xdotool windowwaitunmap {} 2>/dev/null

setsid bash -c "$HOME/willyhorizont.github.io/linux-debian-lxde/i3/start-desktop.sh" >/dev/null 2>&1 &
