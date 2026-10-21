#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.5.10" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
update i3 config, update kb;
update lxde openbox config rc xml, update kb, fix quotation, update kb-goto-wrkspc-prompt.sh, add -p workspace_number;
change lxsession-logout to lxsession-logout -p SPACE80 --hide-button hibernate --hide-button switch_user;
broke lxde openbox autostart;

TODO i3 #1:
fix lxde openbox autostart;
create tui0-powr-mnu-prompt.sh lxsession-logout i3 version;
change dmenu to use .desktop or use rofi;
fix i3 logo not showing in lightdm;
make alt+F4 also delete cur_wrkspc if tot_open_wins 0;
create tui0-i3session-mgr.sh, to set setup i3-desktop.conf;
update i3 config to read i3-desktop.conf;
TODO i3 #2:
--make C-W-t cycle stacking tiling tabbed floating--;
tinkering with i3gaps;
try to add background image in pcmanfm;
set pcmanfm background image;
replace pcmanfm with thunar;
set thunar background image;
autostart thunar ~/Desktop;
try desktop icon in i3, try idesk again;

TODO lxde openbox #1:
TODO lxde openbox #2:
TODO lxde openbox #3:
replace jgmenu with rofi;

TODO #1:
search xtrlock alternative;
on idle autolock show Windows Update or Window BSOD;
TODO #2:
try more bottom panel combo;
try panels again to see features;
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
