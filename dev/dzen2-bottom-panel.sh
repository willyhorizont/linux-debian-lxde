#!/bin/bash

read SCREEN_W SCREEN_H <<< $(xrandr | awk '/\*/ {split($1,a,"x"); print a[1], a[2]; exit}')
HALF_W=$((SCREEN_W / 2))
BAR_H=36
POS_X=$HALF_W
POS_Y=$(((SCREEN_H + 4) - (BAR_H * 2)))

# $HOME/Codes/linux-debian-lxde/dev/dzen2-fastfetch.sh | dzen2 -p -l 1 -x "$POS_X" -y "$POS_Y" -w "$HALF_W" -h "$BAR_H" -ta r -sa r -bg '#000000' -fg '#FF1493' -e 'entertitle=uncollapse;leavetitle=collapse' &
$HOME/Codes/linux-debian-lxde/dev/dzen2-fastfetch.sh | dzen2 -p -l 1 -y "$POS_Y" -h "$BAR_H" -ta r -sa r -bg '#000000' -fg '#FF1493' -e 'entertitle=uncollapse;leavetitle=collapse' &
