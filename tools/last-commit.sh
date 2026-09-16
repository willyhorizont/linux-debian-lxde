#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.1.0" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
update tint2-bottom;
update tint2-top;
replace blueman-applet with bluetoothctl + suckless, add suckless bluetooth indicator;
replace nm-applet with nmcli + nmtui + suckless, add suckless network indicator;
replace fdpowermon with power-profiles-daemon + suckless, add suckless power indicator;
replace volumeicon-alsa with alsamixer + suckless, add suckless audio output indicator;
add font;
update keybind, add keybind to mute mic, update volume up keybind to limit max output;
update autostart;
add audio input indicator;
add video input indicator;
TODO: configure plank theme;
"
M=$(sed -e '/./,$!d' <<< "$M")
M="$H
$M"
touch "$RD/changelog.txt" && awk -v msg="$M" 'BEGIN {print msg; print ""} {print}' "$RD/changelog.txt" > "$RD/changelog.tmp" && mv "$RD/changelog.tmp" "$RD/changelog.txt"
git add changelog.txt
git add .
git commit -m "$M"
git tag -d "$V" 2>/dev/null
git tag -a "$V" -m "$M"
git push origin main
git push origin --tags