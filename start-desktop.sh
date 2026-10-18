#!/bin/sh

(until pactl info >/dev/null 2>&1; do true; done && pactl set-source-mute @DEFAULT_SOURCE@ 1) >/dev/null 2>&1 &

plank &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "plank.Plank" && $9 == "plank" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 1
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-bottom-panel-menu" &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-panel-menu" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 1
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-bottom-panel" &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-panel" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 1
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-bottom-upper-panel" &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-upper-panel" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 1
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-top-bar" &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-top-bar" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 1
done

setsid bash -c "$HOME/willyhorizont.github.io/linux/dmn-wrkspc-mgr.sh" >/dev/null 2>&1 &

setsid bash -c "$HOME/willyhorizont.github.io/linux/dmn-lockr.sh" >/dev/null 2>&1 &
