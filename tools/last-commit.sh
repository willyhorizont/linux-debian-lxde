#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.5.3" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
check apt install history log;
update plank-windows-ten-style.ini, update position;
update README.md, update install command, add i3;
add tint2-bottom-panel-menu;
update restart-desktop.sh, add tint2-bottom-panel-menu kill command;
update start-desktop.sh, add tint2-bottom-panel-menu launch command;
update tint2-bottom-panel, update size;
update tint2-top-bar, update size;
update lxde openbox rc xml, add tint2-bottom-panel-menu;
create tint2-bottom-panel-menu, width follow content, shrink, contain only button menu;
remove jgmenu from plank;

--done with i3--
--cleanup *i3*--
--purgex i3--
keep i3 session with autotiling feh;

progress of making lxde and openbox session work like i3 session:
* infinite workspace with manual auto tiling via keybinds and tile-cur-wrkspc.sh;
;;

TODO:
replace jgmenu with rofi;
try fzf;
remove LXfcDE;
remove debian netinst based;
tinkering with dunstrc;
try to add background image in pcmanfm;
try desktop icon in i3, try idesk again;
tinkering with i3bar i3status i3blocks;
move everything to single install.sh script;
merge willyhorizont.github.io/linux-debian-lxde to willyhorizont.github.io/linux;
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
