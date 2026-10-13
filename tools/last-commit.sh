#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.4.8" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
update plank .ini, alignment start;
update README.md, add install feh command;
move blu-lght-fltr.sh to autostart;
update start-desktop.sh, remove blu-lght-fltr.sh;
update tint2-bottom-panel, add more version;
add pcmanfm .conf;
add i3 shit;
add i3 configr1, blu-lght-fltr.sh, try start-desktop.sh, add vol keybind, add mic keybind, add brightness keybind, add terminal keybind, add file manager keybind, add lock keybind, add screenshot keybind;
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
