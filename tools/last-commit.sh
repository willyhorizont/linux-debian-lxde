#!/bin/bash

while true; do
    read -sp "ARE YOU SURE: " PASS1
    echo ""
    
    if [ -z "$PASS1" ]; then
        echo "❌ Password empty! Please try again."
        echo ""
        continue
    fi

    read -sp "ARE YOU SUPER SURE: " PASS2
    echo ""

    if [ "$PASS1" == "$PASS2" ]; then
        echo "✅ Password match. I hope you super duper sure..."
        echo ""
        break
    else
        echo "❌ Password not match! Please try again."
        echo ""
    fi
done

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.6.0" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
update install.sh, replace lxde openbox config with symlink;
add kb-style-selector-prompt-lxde-openbox.sh;
delete openbox-kill-desktop.sh;
update start-desktop.sh, add --kill, move it to styles/win/start-desktop.sh;
move .config/openbox/autostart to styles/win/.config/openbox/autostart;
move .config/openbox/rc.xml to styles/win/.config/openbox/rc.xml;
move .config/lxsession/LXDE/desktop.conf to styles/win/.config/lxsession/LXDE/desktop.conf;
move .config/lxsession/LXDE/autostart to styles/win/.config/lxsession/LXDE/autostart;
update last-commit.sh, add super confirmation;

TODO #1 i3:
fix i3 openbox logo not showing in lightdm session picker;
make alt+F4 also delete cur_wrkspc if tot_open_wins 0;
try limit tile per ws;
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
make lxde openbox, make all windows always on top, make all windows can not be minimized, make all windows can not be resized, make it extremely auto tiling;
TODO lxde openbox #3:

TODO #2:
try more bottom panel combo;
try panels again to see features;
find panel that have can communicate via some signal;
try tint2 taskbar_mode multi_desktop pager;
try starship or any shell prompt;
try fzf;
try sxhkdrc;
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
