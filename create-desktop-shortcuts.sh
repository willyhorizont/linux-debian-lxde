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
Exec=sh -c '"$HOME/willyhorizont.github.io/linux/tui0-powr-mnu-prompt.sh" "i3-msg exit" "xtrlock"'
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
Exec=i3-msg exit
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
Exec=xtrlock
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
Exec=systemctl poweroff
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
Exec=systemctl reboot
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
Exec=systemctl suspend
Terminal=false
Type=Application
Icon=system-suspend
Categories=System;Utility;Settings;
Keywords=sleep;
OnlyShowIn=LXDE;openbox;i3;
EOF

update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications
