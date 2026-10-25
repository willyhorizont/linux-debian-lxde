#!/bin/sh

openbox --reconfigure

pkill -9 -f "$HOME/willyhorizont.github.io/linux/dmn-lockr.sh" 2>/dev/null

pkill -9 -f "$HOME/willyhorizont.github.io/linux/dmn-wrkspc-mgr.sh" 2>/dev/null

pkill -9 -f "xterm.*-name idle-window" 2>/dev/null
pkill -9 -f "xterm.*-name welcome-window" 2>/dev/null

pkill -9 -x "xpenguins" 2>/dev/null

pkill -9 -f "tint2 -c .*tint2-top-bar" 2>/dev/null
while true; do
    if [ -z "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-top-bar" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

pkill -9 -f "tint2 -c .*tint2-bottom-upper-panel" 2>/dev/null
while true; do
    if [ -z "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-upper-panel" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

pkill -9 -f "tint2 -c .*tint2-bottom-panel" 2>/dev/null
while true; do
    if [ -z "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-panel" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

pkill -9 -f "tint2 -c .*tint2-bottom-panel-menu" 2>/dev/null
while true; do
    if [ -z "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-panel-menu" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

killall -9 plank 2>/dev/null
while true; do
    if [ -z "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "plank.Plank" && $9 == "plank" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done
