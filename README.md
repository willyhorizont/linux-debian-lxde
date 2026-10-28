# Debian LXDE Post Install

![Debian LXDE Screenshot 1](https://github.com/willyhorizont/linux-debian-lxde/blob/main/screenshot1.jpg)  
![Debian LXDE Screenshot 2](https://github.com/willyhorizont/linux-debian-lxde/blob/main/screenshot2.jpg)  
![Debian LXDE Screenshot 3](https://github.com/willyhorizont/linux-debian-lxde/blob/main/screenshot3.jpg)  
![Debian LXDE i3 Screenshot 1](https://github.com/willyhorizont/linux-debian-lxde/blob/main/i3/screenshot1.jpg)  
![Debian LXDE i3 Screenshot 2](https://github.com/willyhorizont/linux-debian-lxde/blob/main/i3/screenshot2.jpg)  
![Debian LXDE i3 Screenshot 3](https://github.com/willyhorizont/linux-debian-lxde/blob/main/i3/screenshot3.jpg)  

## Reverse scroll and Turn on touchpad tapping
```
sudo mkdir -p /etc/X11/xorg.conf.d/ && echo -e 'Section "InputClass"\n    Identifier "touchpad catchall"\n    MatchIsTouchpad "on"\n    MatchDevicePath "/dev/input/event*"\n    Driver "libinput"\n    Option "NaturalScrolling" "true"\n    Option "Tapping" "on"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
```

## Disable Screen Blank
```
sudo mkdir -p /etc/X11/xorg.conf.d/ && sudo tee /etc/X11/xorg.conf.d/10-monitor.conf << 'EOF'
Section "Monitor"
    Identifier "Monitor0"
    Option "DPMS" "false"
EndSection

Section "ServerFlags"
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
    Option "NoPM" "true"
EndSection
EOF
```

## Disable Mouse Acceleration
```
sudo tee /etc/X11/xorg.conf.d/50-mouse-acceleration.conf << 'EOF'
Section "InputClass"
    Identifier "My Pointer Acceleration Override"
    MatchIsPointer "yes"
    Driver "libinput"
    Option "AccelProfile" "flat"
EndSection
EOF
```

## Disable Camera Startup
```
echo "blacklist uvcvideo" | sudo tee /etc/modprobe.d/block-camera.conf
```

## Do [linux > post-install > general.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/general.md#a)

## Do [linux > post-install > debian-apt.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/debian-apt.md#a)

## Install packages
```
# Version Control
sudo apt install -y \
    lazygit \
    git-delta \
    ""

# Locker
sudo apt install -y \
    xprintidle \
    wmctrl \
    xdotool \
    xtrlock \
    ""

# Font
sudo apt install -y fonts-jetbrains-mono

# Brightness control
sudo apt install -y brightnessctl

# Blue Light Filter
sudo apt install -y xsct

# Audio
sudo apt install -y \
    pipewire-audio \
    pipewire-pulse \
    pulseaudio-utils \
    ""

# Bluetooth
sudo apt install -y \
    bluez \
    bluez-tools \
    ""

# Panel
sudo apt install -y tint2

## conf editor
sudo apt install -y dconf-cli

## Screenshot
sudo apt install -y scrot

# Compositor
sudo apt install -y picom
# sudo apt install -y xcompmgr

# Pinned+Opened app combo
sudo apt install -y plank

# Prompt menu
sudo apt install -y rofi

# Power
sudo apt install -y \
    power-profiles-daemon \
    acpi \
    ""

# Notification
sudo apt install -y \
    dunst \
    libnotify-bin \
    ""
```

## Setup Plank
```
dconf dump /net/launchpad/plank/

dconf write /net/launchpad/plank/docks/dock1/alignment "'center'"
dconf write /net/launchpad/plank/docks/dock1/auto-pinning true
dconf write /net/launchpad/plank/docks/dock1/current-workspace-only false
dconf write /net/launchpad/plank/docks/dock1/dock-items "['lxterminal.dockitem', 'pcmanfm.dockitem', 'firefox-esr.dockitem', 'brave-browser.dockitem', 'vivaldi-stable.dockitem', 'chromium.dockitem', 'com.microsoft.VSCode.dockitem']"
dconf write /net/launchpad/plank/docks/dock1/hide-delay 0
dconf write /net/launchpad/plank/docks/dock1/hide-mode "'none'"
dconf write /net/launchpad/plank/docks/dock1/icon-size 36
dconf write /net/launchpad/plank/docks/dock1/items-alignment "'center'"
dconf write /net/launchpad/plank/docks/dock1/lock-items false
dconf write /net/launchpad/plank/docks/dock1/monitor "''"
dconf write /net/launchpad/plank/docks/dock1/offset -94
dconf write /net/launchpad/plank/docks/dock1/pinned-only false
dconf write /net/launchpad/plank/docks/dock1/position "'bottom'"
dconf write /net/launchpad/plank/docks/dock1/pressure-reveal false
dconf write /net/launchpad/plank/docks/dock1/show-dock-item false
dconf write /net/launchpad/plank/docks/dock1/theme "'windows-7-or-10-style'"
dconf write /net/launchpad/plank/docks/dock1/tooltips-enabled true
dconf write /net/launchpad/plank/docks/dock1/unhide-delay 0
dconf write /net/launchpad/plank/docks/dock1/zoom-enabled false
dconf write /net/launchpad/plank/docks/dock1/zoom-percent 150

dconf dump /net/launchpad/plank/

# or

cat "$HOME/willyhorizont.github.io/linux-debian-lxde/styles/windows-7-or-10-style/plank.ini" | dconf load /net/launchpad/plank/docks/

dconf read /net/launchpad/plank/enabled-docks
dconf write /net/launchpad/plank/enabled-docks "['dock1']"
dconf read /net/launchpad/plank/enabled-docks

# to reset something:
# dconf reset /net/launchpad/plank/docks/dock1/icon-size
```

## Disable Daemon
```
# Printer
sudo systemctl disable --now cups-browsed.service
sudo systemctl disable --now cups.service
sudo systemctl disable --now cups.path
sudo systemctl disable --now cups.socket

# Modem
sudo systemctl disable --now ModemManager.service

# Docker
sudo systemctl disable --now docker.service
sudo systemctl disable --now containerd.service
sudo systemctl enable --now docker.socket
```

## Enable Audio
```
systemctl --user daemon-reload
systemctl --user --now enable pipewire
systemctl --user --now enable pipewire-pulse
systemctl --user --now enable wireplumber
```

## Blue Light Filter
```
crontab -l
(crontab -l 2>/dev/null | grep -v "blu-lght-fltr.sh"; echo "*/5 * * * * DISPLAY=:0 bash -c \"\$HOME/willyhorizont.github.io/linux/blu-lght-fltr.sh\" >/dev/null 2>&1") | crontab -
crontab -l
```

## Install config, keybinds, autostart via ```install.sh```

## Restart and refresh the Desktop
```
openbox --reconfigure
```

## Uncheck all except *polkit* in Default application for LXSession > autostart > Known Applications:
```
# copy .desktop from /etc/xdg/autostart/ to ~/.config/autostart/ and add NotShowIn=LXDE;i3;
```

## Copy ```./.config/tint2/start-desktop-.*.sh``` to ```~/.config/tint2/start-desktop-.*.sh```

## Copy ```./.config/lxsession/LXDE/autostart``` to ```~/.config/lxsession/LXDE/autostart```

## Install [linux > themes > gtk2.md](https://github.com/willyhorizont/linux/blob/main/themes/gtk2.md)

## Apply Cursor theme globally
```
sudo update-alternatives --config x-cursor-theme
```

## Adjust notification settings in ```~/.config/dunst/dunstrc```

## Adjust exit menu:
```
## logout
lxsession-logout -p "$(printf '%0.s ' $(seq 1 80))" --hide-button hibernate --hide-button switch_user
"$HOME/willyhorizont.github.io/linux-debian-lxde/lxsession-logout.sh"

## lock screen
sudo mv /usr/bin/lxlock /usr/bin/lxlock.bak
sudo ln -s /usr/bin/xtrlock /usr/bin/lxlock
```

## required for kwh in indic6-powr.sh
```
cat << 'EOF' | sudo tee /etc/systemd/system/rapl-perm.service > /dev/null
[Unit]
Description=Make Intel/AMD RAPL energy_uj readable by user
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "chmod 0444 /sys/class/powercap/intel-rapl/intel-rapl:*/energy_uj"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now rapl-perm.service
# sudo touch /etc/sys_load_mult_factor.txt
# sudo chmod 0666 /etc/sys_load_mult_factor.txt
```

## Create top-bar-free-text.sh
```
mkdir -p ~/willyhorizont.github.io/
cat << 'EOF' > ~/willyhorizont.github.io/top-bar-free-text.sh
#!/bin/bash

echo "Free Text"
EOF
chmod +x ~/willyhorizont.github.io/top-bar-free-text.sh
```

## Create tui0-screensavr desktop shortcut
```
mkdir -p ~/.local/share/applications/
cat << 'EOF' > ~/.local/share/applications/tui0-screensavr.desktop
[Desktop Entry]
Name=tui0-screensavr
Comment=tui0-screensavr
Exec=lxterminal --geometry=88x28 --working-directory=$HOME -e ~/willyhorizont.github.io/linux/tui0-screensavr.sh
Terminal=false
Type=Application
Icon=system-lock-screen
Categories=Settings;
EOF
```

## Create desktop shortcuts -> run ```create-desktop-shortcuts.sh```

## Setup App Tray -> run ```sudo mousepad /usr/share/plank/themes/Transparent/dock.theme``` and change ```BottomPadding=2``` to:
```
BottomPadding=0
LaunchBounceTime=0
```

## Customize Display Manager
```sh
sudo bash -c '
TARGET_FILE="/etc/lightdm/lightdm-gtk-greeter.conf"

# hide user image
if grep -q "#hide-user-image=" "$TARGET_FILE"; then sed -i "s|#hide-user-image=|#hide-user-image=\nhide-user-image=true|g" "$TARGET_FILE"; else sed -i "\$a hide-user-image=true" "$TARGET_FILE"; fi

# change indicator order
sed -i "s|#indicators=|#indicators=\nindicators=~host;~spacer;~clock;~spacer;~session;~power|g" "$TARGET_FILE"

# change clock format
sed -i "s|#clock-format=|#clock-format=\nclock-format=%a, %d %b %Y \| %I:%M:%S %p|g" "$TARGET_FILE"
'
```

## Restart Display Manager
```sudo systemctl restart lightdm```

## Adjust default terminal:
```
sudo update-alternatives --config x-terminal-emulator
```

## Cleanup:
```
# Panel
sudo apt purge -y lxpanel && sudo apt autoremove -y --purge

# Network Manager Applet
sudo apt install -y --no-install-recommends network-manager
sudo apt purge -y network-manager-applet && sudo apt autoremove -y --purge
echo "
Should purge modem:
    modemmanager*
    usb-modeswitch*
    usb-modeswitch-data*
    libmbim-glib4*
    libmbim-proxy*
    libmbim-utils*
    libqmi-glib5*
    libqmi-proxy*
    libqmi-utils*
    libqrtr-glib0*
    mobile-broadband-provider-info*
    libjim0.83*
and purge this:
    libayatana-appindicator3-1*
    nm-connection-editor*
    network-manager-l10n*
In case no network, install this to fix:
    network-manager
    libmm-glib0
    libndp0
    libnm0
    libteamdctl0
and re-install this:
    dns-root-data*
    dnsmasq-base*
    libnma-common*
    libnma0*
"

# Dictionary stuff
sudo apt purge -y goldendict-ng kasumi && sudo apt autoremove -y --purge

# Process Manager
sudo apt purge -y lxtask && sudo apt autoremove -y --purge
sudo apt install -y btop

# Video Player
sudo apt purge -y mplayer && sudo apt autoremove -y --purge
sudo apt install -y mpv

# Power manager
sudo apt purge -y fdpowermon && sudo apt autoremove -y --purge

# Vol widget
sudo apt purge -y xsane sane-utils && sudo apt autoremove -y --purge

# Printer
sudo apt purge -y system-config-printer system-config-printer-common && sudo apt autoremove -y --purge

# App Store
sudo apt purge -y synaptic && sudo apt autoremove -y --purge

# Torrent
sudo apt install -y transmission-gtk
sudo apt purge -y deluge deluge-common deluge-gtk && sudo apt autoremove -y --purge

# Screenshot
sudo apt purge -y \
    gnome-screenshot \
    ""

# Screen locker
sudo apt purge -y \
    xscreensaver \
    gnome-screensaver \
    slock \
    suckless-tools \
    xlock \
    i3lock \
    slimlock \
    xsecurelock \
    && sudo apt autoremove -y --purge

mkdir -p ~/.local/share/applications/
if [ -f /usr/share/applications/display-im7.q16.desktop ]; then cp /usr/share/applications/display-im7.q16.desktop ~/.local/share/applications/ && { if grep -q "^NoDisplay=" "$HOME/.local/share/applications/display-im7.q16.desktop"; then sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$HOME/.local/share/applications/display-im7.q16.desktop"; else sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$HOME/.local/share/applications/display-im7.q16.desktop"; fi; }; fi
if [ -f /usr/share/applications/libreoffice-startcenter.desktop ]; then cp /usr/share/applications/libreoffice-startcenter.desktop ~/.local/share/applications/ && { if grep -q "^NoDisplay=" "$HOME/.local/share/applications/libreoffice-startcenter.desktop"; then sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$HOME/.local/share/applications/libreoffice-startcenter.desktop"; else sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$HOME/.local/share/applications/libreoffice-startcenter.desktop"; fi; }; fi
if [ -f /usr/share/applications/libreoffice-math.desktop ]; then cp /usr/share/applications/libreoffice-math.desktop ~/.local/share/applications/ && { if grep -q "^NoDisplay=" "$HOME/.local/share/applications/libreoffice-math.desktop"; then sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$HOME/.local/share/applications/libreoffice-math.desktop"; else sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$HOME/.local/share/applications/libreoffice-math.desktop"; fi; }; fi
if [ -f /usr/share/applications/libreoffice-draw.desktop ]; then cp /usr/share/applications/libreoffice-draw.desktop ~/.local/share/applications/ && { if grep -q "^NoDisplay=" "$HOME/.local/share/applications/libreoffice-draw.desktop"; then sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$HOME/.local/share/applications/libreoffice-draw.desktop"; else sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$HOME/.local/share/applications/libreoffice-draw.desktop"; fi; }; fi
if [ -f /usr/share/applications/btop.desktop ]; then cp /usr/share/applications/btop.desktop ~/.local/share/applications/ && { sed -i 's|^Exec=.*|Exec=lxterminal --geometry=88x28 --working-directory=$HOME -e btop|; s|^Terminal=.*|Terminal=false|' "$HOME/.local/share/applications/btop.desktop"; }; fi
if [ -f /usr/share/applications/cmatrix.desktop ]; then cp /usr/share/applications/cmatrix.desktop ~/.local/share/applications/ && { sed -i 's|^Exec=.*|Exec=xterm -bc -uc -u8 -fa Monospace -fs 8 -geometry 88x28 -bg black -fg green -e cmatrix -s -u 10 -a|; s|^Terminal=.*|Terminal=false|' "$HOME/.local/share/applications/cmatrix.desktop"; }; fi
if [ -f /usr/share/applications/xterm.desktop ]; then cp /usr/share/applications/xterm.desktop ~/.local/share/applications/ && { sed -i 's|^Exec=.*|Exec=xterm -bc -uc -u8 -fa Monospace -fs 8 -geometry 88x28|; s|^Terminal=.*|Terminal=false|' "$HOME/.local/share/applications/xterm.desktop"; }; fi
if [ -f /usr/share/applications/lxterminal.desktop ]; then cp /usr/share/applications/lxterminal.desktop ~/.local/share/applications/ && { sed -i 's|^Exec=.*|Exec=lxterminal --geometry=88x28 --working-directory=$HOME|; s|^Terminal=.*|Terminal=false|' "$HOME/.local/share/applications/lxterminal.desktop"; }; fi
update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications

# Qt
sudo apt purge -y \
    fcitx-frontend-qt5 \
    fcitx-frontend-qt6 \
    fcitx5-config-qt \
    fcitx5-frontend-qt5 \
    fcitx5-frontend-qt6 \
    libfcitx-qt5-1 \
    libfcitx-qt5-data \
    libfcitx5-qt-data \
    libfcitx5-qt1 \
    libfcitx5-qt6-1 \
    libkf6dbusaddons-bin \
    libkf6dbusaddons-data \
    libkf6dbusaddons6 \
    libkf6itemviews-data \
    libkf6itemviews6 \
    libkf6widgetsaddons-data \
    libkf6widgetsaddons6 \
    libqt5core5t64 \
    libqt5dbus5t64 \
    libqt5gui5t64 \
    libqt5network5t64 \
    libqt5positioning5 \
    libqt5printsupport5t64 \
    libqt5qml5 \
    libqt5qmlmodels5 \
    libqt5quick5 \
    libqt5quickwidgets5 \
    libqt5svg5 \
    libqt5waylandclient5 \
    libqt5waylandcompositor5 \
    libqt5webchannel5 \
    libqt5webengine-data \
    libqt5webenginecore5 \
    libqt5webenginewidgets5 \
    libqt5widgets5t64 \
    libqt5x11extras5 \
    libqt6core6t64 \
    libqt6dbus6 \
    libqt6gui6 \
    libqt6network6 \
    libqt6opengl6 \
    libqt6qml6 \
    libqt6qmlmeta6 \
    libqt6qmlmodels6 \
    libqt6qmlworkerscript6 \
    libqt6quick6 \
    libqt6svg6 \
    libqt6waylandclient6 \
    libqt6waylandcompositor6 \
    libqt6widgets6 \
    libqt6wlshellintegration6 \
    qt5-gtk-platformtheme \
    qt6-gtk-platformtheme \
    qt6-qpa-plugins \
    qt6-svg-plugins \
    qt6-translations-l10n \
    qt6-wayland \
    qttranslations5-l10n \
    qtwayland5 \
    uim-qt5 \
    uim-qt5-immodule \
    uim-qt6 \
    uim-qt6-immodule \
    "" && sudo apt -y autoremove --purge

# non american english input
dpkg -l | grep -i -E "mozc|scim|fcitx"
sudo apt purge -y xiterm+thai && sudo apt autoremove -y --purge
sudo apt purge -y ibus ibus-gtk3 ibus-gtk4 ibus-hangul && sudo apt autoremove -y --purge
sudo apt install -y --no-install-recommends xserver-xorg-input-synaptics
sudo apt install -y --no-install-recommends xserver-xorg-input-all xserver-xorg-input-libinput libinput-bin
sudo apt purge -y uim uim-common uim-gtk3 uim-mozc mozc-server mozc-data && sudo apt autoremove -y --purge
sudo apt purge -y anthy && sudo apt autoremove -y --purge
sudo apt purge -y \
    fcitx-config-common \
    fcitx-config-gtk \
    fcitx-frontend-all \
    fcitx-frontend-gtk2 \
    fcitx-frontend-gtk3 \
    fcitx-module-dbus \
    fcitx-module-kimpanel \
    fcitx-module-lua \
    fcitx-module-x11 \
    fcitx-modules \
    libfcitx-config4 \
    libfcitx-core0 \
    libfcitx-gclient1 \
    libfcitx-utils0 \
    "" && sudo apt autoremove -y --purge
sudo apt purge -y im-config && sudo apt autoremove -y --purge
im-config -n none

# Clipboard
dpkg -l diodon copyq parcellite rofi-greenclip clipster xclip xsel 2>/dev/null
sudo apt purge -y diodon && sudo apt autoremove -y --purge

# Polkit
sudo apt purge -y \
    gnome-system-tools \
    mate-polkit \
    mate-polkit-common \
    "" && sudo apt autoremove -y --purge
```

## Cursor theme
```
sudo apt install -y xcur2png
```

## See [linux > cheatsheet > general.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/general.md)

## See [linux > cheatsheet > debian-apt.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/debian-apt.md)

## i3
```
sudo apt install -y --no-install-recommends \
    i3 \
    autotiling \
    xss-lock \
    xssproxy \
    libxcb-screensaver0 \
    hsetroot \
    polybar \
    # i3blocks \
    ""
```
