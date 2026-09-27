#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.2.10" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
add install.sh;
update restart-desktop.sh;
update start-desktop.sh;
update tint2-bottom-panel;
update tint2-top-bar;
update LXDE session autostart;
update and fix plank theme;
move indicator-bt.sh, indicator-cam.sh, indicator-mic.sh, indicator-net.sh, indicator-powr.sh, indicator-vol.sh, tui-bt.sh, tui-net.sh, tui-powr-pfl.sh to github.com/willyhorizont/linux;
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