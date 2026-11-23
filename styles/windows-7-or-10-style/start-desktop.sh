#!/bin/sh

for pid in $(pgrep -f "start-desktop.sh"); do
    if [ "$pid" != "$$" ]; then
        kill -9 "$pid" 2>/dev/null
    fi
done

# pkill -9 -f ".*willyhorizont.*dmn-auto-tiling.*"                      2>/dev/null
pkill -9 -f ".*xpenguins.*"                                           2>/dev/null
pkill -9 -f ".*willyhorizont.*dmn-screensavr.*"                       2>/dev/null
pkill -9 -f ".*willyhorizont.*tux-indctr.*"                           2>/dev/null

pkill -9 -f ".*willyhorizont.*wrkspc-indctr.*"                        2>/dev/null
pkill -9 -f ".*willyhorizont.*rofi-windows-taskbar-mac-dock.*"        2>/dev/null
pkill -9 -f ".*willyhorizont.*bt.*"                                   2>/dev/null
pkill -9 -f ".*willyhorizont.*net.*"                                  2>/dev/null
pkill -9 -f ".*willyhorizont.*cam.*"                                  2>/dev/null
pkill -9 -f ".*willyhorizont.*mic.*"                                  2>/dev/null
pkill -9 -f ".*willyhorizont.*vol.*"                                  2>/dev/null
pkill -9 -f ".*willyhorizont.*powr-indctr.*"                          2>/dev/null
pkill -9 -f ".*willyhorizont.*SuckMyClock.*"                          2>/dev/null
pkill -9 -f ".*willyhorizont.*SPRM.*"                                 2>/dev/null

pkill -9 -f "tint2 -c .*tint2-top-bar" 2>/dev/null
while true; do
    if [ -z "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-top-bar" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

pkill -9 -f "tint2 -c .*tint2-bottom-panel" 2>/dev/null
while true; do
    if [ -z "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-panel" {print $0}' 2>/dev/null)" ]; then
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

openbox --reconfigure

xset -dpms >/dev/null 2>&1 &
xset s 240 240 >/dev/null 2>&1 &
xset s noblank >/dev/null 2>&1 &
xss-lock --transfer-sleep-lock -- xtrlock &

(until pactl info >/dev/null 2>&1; do true; done && pactl set-source-mute @DEFAULT_SOURCE@ 1) >/dev/null 2>&1 &

tint2 -c "$HOME/willyhorizont.github.io/.config/tint2-bottom-panel" &
while true; do
    if [ -n "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-panel" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

tint2 -c "$HOME/willyhorizont.github.io/.config/tint2-top-bar" &
while true; do
    if [ -n "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-top-bar" {print $0}' 2>/dev/null)" ]; then
        break
    fi
    sleep 0.2
done

# setsid bash -c "$HOME/willyhorizont.github.io/linux/dmn-auto-tiling.sh" >/dev/null 2>&1 &

setsid bash -c "$HOME/willyhorizont.github.io/linux/dmn-screensavr.sh" >/dev/null 2>&1 &
