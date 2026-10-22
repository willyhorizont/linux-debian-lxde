#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.5.14" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
update install.sh, add refresh .desktop;
update lxsession-logout.sh, add --lock --logout --suspend --reboot --shutdown;
update README.md, link lxlock to xtrlock, add create lxsession-logout.sh .desktop;
replace jgmenu with rofi;
remove rofi main-menu.sh;
use vanilla rofi -show drun for all lxde openbox i3;
update jgmenurc, delete it soon;
update jgmenu prepend.csv, delete it soon;
update lxde openbox rc xml config, replace jgmenu_run with rofi -show drun;
update i3 config, add more rofi kb;
update rofi config, disable history, disable sorting, disable scrollbar, hide scrollbar;
update tint2-bottom-panel-menu, replace jgmenu_run with rofi -show drun;
update tint2-bottom-panel, replace jgmenu_run with rofi -show drun;

TODO #1 i3:
fix i3 openbox logo not showing in lightdm session picker;
make alt+F4 also delete cur_wrkspc if tot_open_wins 0;
create tui0-i3session-mgr.sh, to set setup i3-desktop.conf;
update i3 config to read i3-desktop.conf;

TODO #1 lxde openbox:
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
