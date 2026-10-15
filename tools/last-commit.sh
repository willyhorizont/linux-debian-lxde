#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.5.0" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
done with i3, openbox match the needs
finish make lxde and openbox session work like i3 session, infinite workspace with manual auto tiling via keybinds and tile-cur-wrkspc.sh;
update lxde openbox rc xml config, add tiling keybinds;

TODO:
create bottom-panel-menu, width follow content, shrink, contain only button menu;
remove menu from plank;
check apt install history;
cleanup *i3*;
purgex i3;
remove LXFcDE;
remove debian netinst based;
merge willyhorizont.github.io/linux-debian-lxde to willyhorizont.github.io/linux;
move everything to single install.sh script;
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
