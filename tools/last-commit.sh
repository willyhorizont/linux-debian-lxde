#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.5.12" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
fix lxde openbox autostart;
create tui0-powr-mnu-prompt.sh lxsession-logout i3 version;
add lxsession-logout.sh;
update README.md, revert disable scren blank command remove xset, fix cron job;
update jgmenu config, update power menu to use lxsession-logout.sh;
update lxsession desktop.conf, update quit_manager command to use lxsession-logout.sh;
update lxsession lxde autostart, add xset, update blu-lght-fltr.sh start-desktop.sh launch command;
update openbox autostart, add xset, update blu-lght-fltr.sh start-desktop.sh launch command;
update lxde openbox rc xml config, update kb to use lxsession-logout.sh;
update sleep;
update openbox-kill-desktop.sh, update sleep;
update start-desktop.sh, update sleep, add xset to disable blank screen;
add i3 start-desktop.sh;

TODO i3 #1:
change dmenu to use .desktop or use rofi;
fix i3 openbox logo not showing in lightdm session picker;
make alt+F4 also delete cur_wrkspc if tot_open_wins 0;
create tui0-i3session-mgr.sh, to set setup i3-desktop.conf;
update i3 config to read i3-desktop.conf;

TODO lxde openbox #1:
add refresh-desktop.sh to desktop RMB menu;
TODO #1:
search xtrlock alternative;
on idle autolock show Windows Update or Windows BSOD;

TODO i3 #2:
--make C-W-t cycle stacking tiling tabbed floating--;
tinkering with i3gaps;
try to add background image in pcmanfm;
set pcmanfm background image;
replace pcmanfm with thunar;
set thunar background image;
autostart thunar ~/Desktop;
try desktop icon in i3, try idesk again;

TODO lxde openbox #2:
TODO lxde openbox #3:
replace jgmenu with rofi;

TODO #2:
try more bottom panel combo;
try panels again to see features;
find panel that have can communicate via some signal;
try tint2 taskbar_mode multi_desktop pager;
try starship or any shell prompt;
try fzf;
TODO #3:
remove LXfcDE;
remove debian netinst based;
tinkering with dunstrc;
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
