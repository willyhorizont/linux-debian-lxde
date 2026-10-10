#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.4.2" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
update xterm call;
update install.sh restart-desktop command;
update README.md, add im-config diodon purge command, add xsct blue light filter install command; add cronjob crontab blue light filter command, add lxterminal desktop;
fix restart-desktop.sh, kill specific xterm with welcome-window idle-window classname;
update start-desktop.sh, add blu-lght-fltr.sh;
update tint2-top-bar, replace xterm with lxterminal;
update tint2-bottom-panel, replace xterm with lxterminal;
update update sync.sh install command;
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
