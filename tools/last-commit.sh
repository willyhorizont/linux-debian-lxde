#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.4.9" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
add openbox rc.xml config;
add lxde lxde-rc.xml config;
add openbox autostart config;
update install.sh, add copy lxde config for openbox command;
update README.md, change to copy lxde config for openbox command;
update tint2-top-bar, make height smaller;
update tint2-bottom-panel, make the width half;
add tint2-bottom-upper-panel to display workspaces;
update restart-desktop.sh, add tint2-bottom-upper-panel kill command, add dmn-openbox-wrkspc.sh kill command;
update start-desktop.sh, add tint2-bottom-upper-panel launch command, add dmn-openbox-wrkspc.sh launch command;
add more i3 shit, add tint2-bottom-panel-i3, install.sh, restart-desktop.sh, start-desktop.sh, sync-i3.sh;
small update i3 configr1;
success make openbox session work like lxde session;
attempt 1 make i3 session work like lxde session, pcmanfm as desktop wallpaper and desktop icon manager, tint2-bottom-panel, tint2-top-bar, plank, dmn-locker.sh --shw-win false --shw-tux false;
attempt 1 make lxde and openbox session work like i3 session, infinite workspace;
add keybinds to openbox-nu-wrkspc.sh, openbox-mov-win-to-wrkspc.sh, tile-cur-wrkspc.sh;
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
