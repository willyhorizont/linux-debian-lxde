#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.5.8" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
update i3 config;
add polybar config;
delete i3 install.sh;
delete i3 restart-desktop.sh;
delete i3 start-desktop.sh;
delete sync-i3.sh;
update i3 README.md, add bottom panel combo list;
update install.sh, make it universal, remove openbox, remove restart-desktop.sh, add polybar config;
update sync.sh, make it universal, remove install.sh;
rename restart-desktop to openbox-kill-desktop, remove start-desktop;
update README.md, update disable screen blank and fix idle autolock, add version control, add mate-polkit purge command, update i3 install command add polybar replace feh with hsetroot;
update tint2-bottom-panel-i3;
delete polkit-mate-authentication-agent-1.desktop mate-polkit from autostart;
update vscode settings.json, set window.menuStyle to custom, set window.titleBarStyle to native;

--done with i3--
--cleanup *i3*--
--purgex i3--
keep i3 session with autotiling hsetroot;
tinkering with i3bar i3status;
tinkering with i3gaps;

progress of making lxde and openbox session work like i3 session:
* infinite workspace with manual auto tiling via keybinds and kb-tile-cur-wrkspc.sh;
;;

TODO:
try more bottom panel combo;
make C-W-t cycle stacking tiling tabbed floating
make alt+F4 also delete cur_wrkspc if tot_open_wins 0
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
