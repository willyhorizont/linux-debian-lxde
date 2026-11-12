#!/bin/bash

$HOME/willyhorizont.github.io/linux/confirm-cmd.sh || exit 1

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.8.0" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
[new]
replace wmctrl -l -x -G with wmctrl-lxcapg.sh;
update lxsession-logout.sh, replace wmctrl -l -x -G with wmctrl-lxcapg.sh;
add rofi-app-menu.sh;
update rofi-fav-apps.sh, add --yoffset --xoffset --number, rename --flip to --invert;
update run-session.sh, replace wmctrl -l -x -G with wmctrl-lxcapg.sh;
update i3 run-session.sh, replace wmctrl -l -x -G with wmctrl-lxcapg.sh;
rename tint2-bottom-panel-menu to tint2-bottom-left-panel;
rename tint2-bottom-upper-panel to tint2-bottom-right-panel-top;
rename tint2-bottom-panel to tint2-bottom-right-panel-bottom;
replace tint2-bottom-left-panel tint2-bottom-right-panel-top tint2-bottom-right-panel-bottom with tint2-bottom-panel;
move lxde openbox wrkspc-mgr.sh from linux repo to this repo, add --max-width;
move lxde openbox wrkspc-indctr.sh from linux repo to this repo, add --max-width --pref --suff;
update i3 wrkspc-indctr.sh, add --max-width --pref --suff;
fix start-desktop.sh, fix kill;
fix i3 start-desktop.sh, fix kill;
update i3 config, use new rofi-app-menu.sh, replace HOME with grave;
update lxde openbox rc xml config, use new rofi-app-menu.sh, replace HOME with grave;
create i3 windows-7-or-10-style;
set i3 default style to windows-7-or-10-style;

[working on]
create system tray rofi;
customize i3 title bar;
goto desktop open pcmanfm desktop dir;

[TODO #1 i3]
fix i3 openbox logo not showing in lightdm session picker;
try limit tile per ws;

[TODO #1 lxde openbox]
add refresh-desktop.sh to desktop RMB menu;

[TODO #1]
add --pango to --indicator *indctr;
fix screenshot, maybe try flameshot scrot i3-scrot;
add screen recorder, maybe obs screen recorder via flatpak;
add /bin/bash to shell prompt, maybe add distro and session also;
add i3 openbox lxde logo to wallpaper;
add Pango Markup;
add --pango to tint2;
execp_markup = 1 to tint2;
search xtrlock alternative;
on idle autolock show Windows Update or Windows BSOD;

[TODO i3 #2]
tinkering with i3gaps;
try to add background image in pcmanfm;
set pcmanfm background image;
replace pcmanfm with thunar;
set thunar background image;
autostart thunar ~/Desktop;
try desktop icon in i3, try idesk again;

[TODO lxde openbox #2]
make lxde openbox, make all windows always on top, make all windows can not be minimized, make all windows can not be resized, make it extremely auto tiling;
[TODO lxde openbox #3]

[TODO #2]
make window font size smaller;
try more bottom panel combo;
try panels again to see features;
find panel that have can communicate via some signal;
find panel that have can communicate via some signal, maybe try dwmblocks xsetroot dwmblocks-async i3blocks;
try tint2 taskbar_mode multi_desktop pager;
try sxhkd sxhkdrc;
[TODO #3]
backup ~/.profile after another setup;
remove LXfcDE;
remove debian netinst based;
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
