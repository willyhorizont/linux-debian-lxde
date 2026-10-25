#!/bin/sh

cat "$HOME/willyhorizont.github.io/linux-debian-lxde/styles/windows-7-or-10-style/plank.ini" | dconf load /net/launchpad/plank/docks/

openbox --reconfigure

pkill -9 -f "$HOME/willyhorizont.github.io/linux/dmn-screensavr.sh" 2>/dev/null

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

while [ "$#" -gt 0 ]; do
    case "$1" in
        --kill)
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

xset -dpms >/dev/null 2>&1 &
xset s 240 240 >/dev/null 2>&1 &
xset s noblank >/dev/null 2>&1 &
xss-lock --transfer-sleep-lock -- xtrlock &

(until pactl info >/dev/null 2>&1; do true; done && pactl set-source-mute @DEFAULT_SOURCE@ 1) >/dev/null 2>&1 &

plank &
while true; do
    wid_plank=$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "plank.Plank" && $9 == "plank" {print $1}' 2>/dev/null)
    if [ -n "$wid_plank" ]; then
        break
    fi
    sleep 0.2
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/styles/windows-7-or-10-style/tint2-bottom-panel-menu" &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-panel-menu" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/styles/windows-7-or-10-style/tint2-bottom-panel" &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-panel" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/styles/windows-7-or-10-style/tint2-bottom-upper-panel" &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-upper-panel" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/styles/windows-7-or-10-style/tint2-top-bar" &
while true; do
    if [ -n "$(wmctrl -l -x -G | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-top-bar" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

xdotool windowactivate --sync "$wid_plank"
# wmctrl -i -a "$wid_plank"
# wmctrl -x -a "plank.Plank"

setsid bash -c "$HOME/willyhorizont.github.io/linux/dmn-screensavr.sh" >/dev/null 2>&1 &
