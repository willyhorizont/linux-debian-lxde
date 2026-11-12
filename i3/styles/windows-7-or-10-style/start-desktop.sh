#!/bin/sh

for pid in $(pgrep -f "start-desktop.sh"); do
    if [ "$pid" != "$$" ]; then
        kill -9 "$pid" 2>/dev/null
    fi
done

pkill -9 -f ".*willyhorizont.*wrkspc-indctr.*"                        2>/dev/null
pkill -9 -f ".*willyhorizont.*rofi-fav-apps.*"                        2>/dev/null
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

# pkill -9 -f "tint2 -c .*tint2-bottom-right-panel-top" 2>/dev/null
# while true; do
#     if [ -z "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-right-panel-top" {print $0}' 2>/dev/null)" ]; then
#         break
#     fi
#     sleep 0.2
# done

# pkill -9 -f "tint2 -c .*tint2-bottom-right-panel-bottom" 2>/dev/null
# while true; do
#     if [ -z "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-right-panel-bottom" {print $0}' 2>/dev/null)" ]; then
#         break
#     fi
#     sleep 0.2
# done

# pkill -9 -f "tint2 -c .*tint2-bottom-left-panel" 2>/dev/null
# while true; do
#     if [ -z "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-left-panel" {print $0}' 2>/dev/null)" ]; then
#         break
#     fi
#     sleep 0.2
# done

# pkill -9 -f "plank" 2>/dev/null
# while true; do
#     if [ -z "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "plank.Plank" && $9 == "plank" {print $0}' 2>/dev/null)" ]; then
#         break
#     fi
#     sleep 0.2
# done

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

# cat "$HOME/willyhorizont.github.io/.config/plank.ini" | dconf load /net/launchpad/plank/docks/

openbox --reconfigure

xset -dpms >/dev/null 2>&1 &
xset s 240 240 >/dev/null 2>&1 &
xset s noblank >/dev/null 2>&1 &
xss-lock --transfer-sleep-lock -- xtrlock &

(until pactl info >/dev/null 2>&1; do true; done && pactl set-source-mute @DEFAULT_SOURCE@ 1) >/dev/null 2>&1 &

# plank &
# while true; do
#     wid_plank=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "plank.Plank" && $9 == "plank" {print $1}' 2>/dev/null)
#     if [ -n "$wid_plank" ]; then
#         break
#     fi
#     sleep 0.2
# done

# tint2 -c "$HOME/willyhorizont.github.io/.config/i3/tint2-bottom-left-panel" &
# while true; do
#     if [ -n "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-left-panel" {print $0}' 2>/dev/null)" ]; then
#         break
#     fi
#     sleep 0.2
# done

# tint2 -c "$HOME/willyhorizont.github.io/.config/i3/tint2-bottom-right-panel-bottom" &
# while true; do
#     if [ -n "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-right-panel-bottom" {print $0}' 2>/dev/null)" ]; then
#         break
#     fi
#     sleep 0.2
# done

# tint2 -c "$HOME/willyhorizont.github.io/.config/i3/tint2-bottom-right-panel-top" &
# while true; do
#     if [ -n "$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$2 == "-1" && $7 == "tint2.Tint2" && $9 == "tint2-bottom-right-panel-top" {print $0}' 2>/dev/null)" ]; then
#         break
#     fi
#     sleep 0.2
# done

tint2 -c "$HOME/willyhorizont.github.io/.config/i3/tint2-bottom-panel" &
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

#xdotool windowactivate --sync "$wid_plank"
## wmctrl -i -a "$wid_plank"
## wmctrl -x -a "plank.Plank"

# setsid bash -c "$HOME/willyhorizont.github.io/linux/dmn-auto-tiling.sh" >/dev/null 2>&1 &

# setsid bash -c "$HOME/willyhorizont.github.io/linux/dmn-screensavr.sh" >/dev/null 2>&1 &
