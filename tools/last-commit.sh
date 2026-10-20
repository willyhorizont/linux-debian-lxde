#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.5.9" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
update tint2-bottom-panel-i3, remove Button Toggle Show Desktop;
update polybar config.ini, change color;
update i3 README.md;
add setup-comparison.sh;
add setup-comparison.csv;
add setup-rank.csv;
fix screenshot kb;

canceled:
--done with i3--;
--cleanup *i3*--;
--purgex i3--;
--keep i3 session with autotiling hsetroot--;
--tinkering with i3bar i3status i3blocks--;

TODO i3:
make C-W-t cycle stacking tiling tabbed floating;
make alt+F4 also delete cur_wrkspc if tot_open_wins 0;
lxsession-logout i3 version;
create tui0-i3session-mgr.sh, to set setup i3-desktop.conf;
tinkering with i3gaps;
set pcmanfm background image;
replace pcmanfm with thunar;
set thunar background image;
autostart thunar ~/Desktop;
try desktop icon in i3, try idesk again;

TODO lxde openbox:
replace jgmenu with rofi;

TODO:
try more bottom panel combo;
try panels again to see features;
try starship or any shell prompt;
try fzf;
remove LXfcDE;
remove debian netinst based;
tinkering with dunstrc;
try to add background image in pcmanfm;
add run-session*.sh to ~/.bashrc;
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
