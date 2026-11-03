#!/bin/sh

mkdir -p ~/.local/share/applications/

cat << EOF > ~/.local/share/applications/exit-lxde.desktop
[Desktop Entry]
Name=Exit
Comment=Exit
Exec=sh -c "$HOME/willyhorizont.github.io/linux-debian-lxde/lxsession-logout.sh"
Terminal=false
Type=Application
Icon=system-shutdown
Categories=System;Utility;Settings;
OnlyShowIn=LXDE;
EOF

cat << EOF > ~/.local/share/applications/logout-lxde.desktop
[Desktop Entry]
Name=Logout
Comment=Logout
Exec=sh -c "$HOME/willyhorizont.github.io/linux-debian-lxde/lxsession-logout.sh --logout"
Terminal=false
Type=Application
Icon=system-log-out
Categories=System;Utility;Settings;
OnlyShowIn=LXDE;
EOF

cat << EOF > ~/.local/share/applications/exit-openbox.desktop
[Desktop Entry]
Name=Exit
Comment=Exit
Exec=sh -c "$HOME/willyhorizont.github.io/linux-debian-lxde/lxsession-logout.sh"
Terminal=false
Type=Application
Icon=system-shutdown
Categories=System;Utility;Settings;
OnlyShowIn=openbox;
EOF

cat << EOF > ~/.local/share/applications/logout-openbox.desktop
[Desktop Entry]
Name=Logout
Comment=Logout
Exec=sh -c "$HOME/willyhorizont.github.io/linux-debian-lxde/lxsession-logout.sh --logout"
Terminal=false
Type=Application
Icon=system-log-out
Categories=System;Utility;Settings;
OnlyShowIn=openbox;
EOF

cat << EOF > ~/.local/share/applications/exit-i3.desktop
[Desktop Entry]
Name=Exit
Comment=Exit
Exec=sh -c '"$HOME/willyhorizont.github.io/linux/powr-mnu.sh" "i3-msg exit" "xtrlock"'
Terminal=false
Type=Application
Icon=system-shutdown
Categories=System;Utility;Settings;
OnlyShowIn=i3;
EOF

cat << EOF > ~/.local/share/applications/logout-i3.desktop
[Desktop Entry]
Name=Logout
Comment=Logout
Exec=sh -c '"$HOME/willyhorizont.github.io/linux/powr-mnu.sh" "i3-msg exit" "xtrlock"' --logout
Terminal=false
Type=Application
Icon=system-log-out
Categories=System;Utility;Settings;
OnlyShowIn=i3;
EOF

cat << EOF > ~/.local/share/applications/lock.desktop
[Desktop Entry]
Name=Lock
Comment=Lock
Exec=sh -c '"$HOME/willyhorizont.github.io/linux/powr-mnu.sh" "i3-msg exit" "xtrlock"' --lock
Terminal=false
Type=Application
Icon=system-lock-screen
Categories=System;Utility;Settings;
OnlyShowIn=LXDE;openbox;i3;
EOF

cat << EOF > ~/.local/share/applications/shutdown.desktop
[Desktop Entry]
Name=Shutdown
Comment=shutdown
Exec=sh -c '"$HOME/willyhorizont.github.io/linux/powr-mnu.sh" "i3-msg exit" "xtrlock"' --shutdown
Terminal=false
Type=Application
Icon=system-shutdown
Categories=System;Utility;Settings;
Keywords=poweroff;
OnlyShowIn=LXDE;openbox;i3;
EOF

cat << EOF > ~/.local/share/applications/reboot.desktop
[Desktop Entry]
Name=Reboot
Comment=reboot
Exec=sh -c '"$HOME/willyhorizont.github.io/linux/powr-mnu.sh" "i3-msg exit" "xtrlock"' --reboot
Terminal=false
Type=Application
Icon=system-reboot
Categories=System;Utility;Settings;
Keywords=restart;
OnlyShowIn=LXDE;openbox;i3;
EOF

cat << EOF > ~/.local/share/applications/suspend.desktop
[Desktop Entry]
Name=Suspend
Comment=suspend
Exec=sh -c '"$HOME/willyhorizont.github.io/linux/powr-mnu.sh" "i3-msg exit" "xtrlock"' --suspend
Terminal=false
Type=Application
Icon=system-suspend
Categories=System;Utility;Settings;
Keywords=sleep;
OnlyShowIn=LXDE;openbox;i3;
EOF

for APP_NAME in \
    "display-im7.q16" \
    "libreoffice-startcenter" \
    "libreoffice-math" \
    "libreoffice-draw" \
    "rofi-theme-selector" \
    "rofi" \
    "vim" \
; do
    if [ -f "/usr/share/applications/$APP_NAME.desktop" ]; then
        cp "/usr/share/applications/$APP_NAME.desktop" ~/.local/share/applications/ && {
            if grep -q "^NoDisplay=" "$HOME/.local/share/applications/$APP_NAME.desktop"; then
                sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$HOME/.local/share/applications/$APP_NAME.desktop"
            else
                sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$HOME/.local/share/applications/$APP_NAME.desktop"
            fi
        }
    fi
done

modify_desktop_shorcuts() {
    local file_name="$1"
    local sed_script="$2"
    if [ -f "/usr/share/applications/$file_name" ]; then
        cp "/usr/share/applications/$file_name" ~/.local/share/applications/ && {
            sed -i "$sed_script" "$HOME/.local/share/applications/$file_name"
        }
    fi
}

for KV in \
    'debian-xterm.desktop;  s|^Terminal=.*|Terminal=false|; s|^Exec=.*|Exec=xterm -bc -uc -u8 -fa Monospace -fs 8 -geometry 88x28|' \
    'lxterminal.desktop;    s|^Terminal=.*|Terminal=false|; s|^Exec=.*|Exec=lxterminal --geometry=88x28 --working-directory=$HOME|' \
    'rxvt-unicode.desktop;  s|^Terminal=.*|Terminal=false|; s|^Icon=.*|Icon=utilities-terminal|; s|^Name=.*|Name=URxvt|; s|^Exec=.*|Exec=urxvt -bc -uc -pt root -fn "xft:Monospace:size=8" -geometry 88x28|; s|^OnlyShowIn=.*||g' \
    'Alacritty.desktop;     s|^Terminal=.*|Terminal=false|; s|^Icon=.*|Icon=utilities-terminal|' \
    'btop.desktop;          s|^Terminal=.*|Terminal=false|; s|^Exec=.*|Exec=lxterminal --geometry=88x28 --working-directory=$HOME -e btop|' \
    'cmatrix.desktop;       s|^Terminal=.*|Terminal=false|; s|^Exec=.*|Exec=xterm -bc -uc -u8 -fa Monospace -fs 8 -geometry 88x28 -xrm "XTerm*color2: #008000" -xrm "XTerm*color7: #FFFFFF" -e cmatrix -s -u 10 -a|' \
    'fresh.desktop;         s|^Terminal=.*|Terminal=false|; s|^Exec=.*|Exec=alacritty --option window.dimensions.columns=88 window.dimensions.lines=28 -e fresh %F|' \
; do
    FILE_NAME="${KV%%;*}"
    RAW_SED="${KV#*;}"
    SED_ARGS="${RAW_SED#"${RAW_SED%%[![:space:]]*}"}"
    modify_desktop_shorcuts "$FILE_NAME" "$SED_ARGS"
done

update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications
