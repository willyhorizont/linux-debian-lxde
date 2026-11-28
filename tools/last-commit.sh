#!/bin/bash

$HOME/willyhorizont.github.io/linux/confirm-cmd.sh --msg "Confirm Commit" || exit 1

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
V="0.11.1" # ! DON'T FORGET TO CHANGE VERSION BEFORE RUNNING !!!!
T=$(date "+%d %b %Y @ %I:%M %p")
cd "$RD" || exit

H="
[Last updated: $T][version: $V]
"
H=$(sed -e '/./,$!d' <<< "$H")
# ! DON'T FORGET TO CHANGE COMMIT MESSAGE BEFORE RUNNING !!!!
M="
[new]
update create-desktop-shortcut.sh, small fix in cmatrix.desktop;
update wrkspc-indctr.sh, add debounce;

[working on]
add text editor to fav apps;
create caja config;
create mousepad config;
create pluma config;
create tilix config;
create tilix window rule;
create kitty config;
create kitty window rule;
try xfdesktop4;
create tilda config;
create tilda window rule;
create l3afpad config;
create l3afpad window rule;
add fastfetch on click avatar whiskermenu;
change caja .desktop icon;
create lock.sh, open idle win on lock kb press in lxde openbox;
create panic.sh, cover screen with windows bsod or windows update;
create control-center.sh;
create lock-mgr.sh;
create windows-control-panel.sh;
try running xpenguins on i3 container;
try running xpenguins on caja;
tinkering with lightdm, theming, session position;
create base i3 start-desktop.sh;
create base i3 config;
create base lxde openbox rc xml config;
create base lxde openbox start-desktop.sh;
create base lxde openbox autostart;
rename styles windows-7-or-10-style to tint2;
rename i3 styles windows-7-or-10-style to tint2;
fix xfce4-panel --quit and --restart if still buggy;
add styles xfce4-panel;
add i3 styles xfce4-panel;
update wrkspc-indctr.sh, add --mode xfce4-panel <txt></txt>\n<txtclick></txtclick>\n<tool></tool>;
create tiling wm autotiling program;

[TODO #1 i3]
fix i3 openbox logo not showing in lightdm session picker;
try limit tile per ws;

[TODO #1 lxde openbox]
add refresh-desktop.sh to desktop RMB menu;

[TODO #1]
create rofi Windows Notification Area or System Tray / Mac Menu Bar Extras or Status Menus / Linux Status Notifier Area or System Tray;
customize i3 title bar;
add icon to rofi-fav-apps.sh;
create xalendar.py holiday-calendar.py;
try qtile (EWMH, default panel have my 3 req feature);
try awesomewm (EWMH, default panel have my 3 req feature);
try notionwm, sudo apt install notion;
try herbstluftwm (EWMH);
try spectrwm (Not EWMH);
try bspwm (Not EWMH, need sxhkd);
try dwm; (Not EWMH, need compile);
--try xmonad--, reason: haskell;
--try leftwm--, reason: no apt install;
--try Eww (ElKowar's Wacky Widgets - X11 & Wayland) (defpoll/deflisten + :tooltip + :onclick)--, reason no apt install;
try dzen2;
--try MATE Panel (mate-panel + Command Applet mate-applets)--, reason too much bloat;
try LXPanel;
try XFCE4 Panel (xfce4-genmon-plugin <txt> + <tool>content</tool> sed 's/&/&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' + <txtclick>cmd_click</txtclick> (or <click> for icon));
try AwesomeWM (awful.widget.watch + awful.tooltip + widget:buttons(...));
try Qtile (GenPollText / GenPollCommand + qtile-extras TooltipMixin + mouse_callbacks={'Button1': lazy.spawn(...)});
install flatpak;
install flameshot;
install obs via flatpak;
try pavucontrol;
fix screenshot, maybe try flameshot scrot i3-scrot;
add screen recorder, maybe obs screen recorder via flatpak;
add /bin/bash to shell prompt, maybe add distro and session also;
add i3 openbox lxde logo to wallpaper;
search xtrlock alternative;
on idle autolock show Windows Update or Windows BSOD;

[TODO i3 #2]
[TODO i3 #3]
tinkering with i3gaps;

[TODO lxde openbox #2]
[TODO lxde openbox #3]
make lxde openbox, make all windows always on top, make all windows can not be minimized, make all windows can not be resized, make it extremely auto tiling;

[TODO #2]
make window font size smaller;
try more bottom panel combo;
try panels again to see features;
find panel that have can communicate via some signal;
find panel that have can communicate via some signal, maybe try dwmblocks xsetroot dwmblocks-async i3blocks;
try vertical panel only for open wins in cur ws;
try create vertical panel only for open winds in cur ws using ElKowar's Wacky Widgets;
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
