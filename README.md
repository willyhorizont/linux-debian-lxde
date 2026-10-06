# Debian LXDE Post Install

![Debian LXDE Screenshot](https://github.com/willyhorizont/linux-debian-lxde/blob/main/screenshot.jpg)  

## Reverse scroll and Turn on touchpad tapping
```
sudo mkdir -p /etc/X11/xorg.conf.d && echo -e 'Section "InputClass"\n    Identifier "touchpad catchall"\n    MatchIsTouchpad "on"\n    MatchDevicePath "/dev/input/event*"\n    Driver "libinput"\n    Option "NaturalScrolling" "true"\n    Option "Tapping" "on"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
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
# Screen locker
sudo apt install -y xtrlock

# Font
sudo apt install -y fonts-jetbrains-mono

# Brightness control
sudo apt install -y brightnessctl

# Audio
sudo apt install -y \
    pipewire-audio \
    pipewire-pulse \
    pulseaudio-utils \
    ""

# Bluetooth
sudo apt install -y blueman

# Panel
sudo apt install -y \
    dconf-cli \
    xprintidle \
    xdotool \
    scrot \
    picom \ # or xcompmgr
    tint2 \
    plank \
    jgmenu \
    power-profiles-daemon \
    acpi \
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
dconf write /net/launchpad/plank/docks/dock1/dock-items "['bottom-panel-app-launcher.dockitem', 'lxterminal.dockitem', 'pcmanfm.dockitem', 'firefox-esr.dockitem', 'brave-browser.dockitem', 'vivaldi-stable.dockitem', 'google-chrome.dockitem', 'com.microsoft.VSCode.dockitem']"
dconf write /net/launchpad/plank/docks/dock1/hide-delay 0
dconf write /net/launchpad/plank/docks/dock1/hide-mode "'none'"
dconf write /net/launchpad/plank/docks/dock1/icon-size 36
dconf write /net/launchpad/plank/docks/dock1/items-alignment "'center'"
dconf write /net/launchpad/plank/docks/dock1/lock-items false
dconf write /net/launchpad/plank/docks/dock1/monitor "''"
dconf write /net/launchpad/plank/docks/dock1/offset -100
dconf write /net/launchpad/plank/docks/dock1/pinned-only false
dconf write /net/launchpad/plank/docks/dock1/position "'bottom'"
dconf write /net/launchpad/plank/docks/dock1/pressure-reveal false
dconf write /net/launchpad/plank/docks/dock1/show-dock-item false
dconf write /net/launchpad/plank/docks/dock1/theme "'WindowsTenStyle'"
dconf write /net/launchpad/plank/docks/dock1/tooltips-enabled true
dconf write /net/launchpad/plank/docks/dock1/unhide-delay 0
dconf write /net/launchpad/plank/docks/dock1/zoom-enabled false
dconf write /net/launchpad/plank/docks/dock1/zoom-percent 150

dconf dump /net/launchpad/plank/

# or

cat "$HOME/willyhorizont.github.io/linux-debian-lxde/plank-windows-ten-style.ini" | dconf load /net/launchpad/plank/docks/

dconf read /net/launchpad/plank/enabled-docks
dconf write /net/launchpad/plank/enabled-docks "['dock1']"
dconf read /net/launchpad/plank/enabled-docks
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

## Add keybinds -> open ```~/.config/openbox/lxde-rc.xml``` and add this:
```xml
    <!-- Lock screen -->
    <keybind key="C-W-l">
        <action name="Execute">
        <command>xtrlock</command>
        </action>
    </keybind>
    <!-- Audio control -->
    <keybind key="XF86AudioRaiseVolume">
      <action name="Execute">
        <command>bash -c 'pactl set-sink-volume @DEFAULT_SINK@ +5% &amp;&amp; VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk "{print \$5}" | head -n1 | tr -d "%"); if [ "$VOL" -gt 100 ]; then pactl set-sink-volume @DEFAULT_SINK@ 100%; fi'</command>
      </action>
    </keybind>
    <keybind key="XF86AudioLowerVolume">
      <action name="Execute">
        <command>pactl set-sink-volume @DEFAULT_SINK@ -5%</command>
      </action>
    </keybind>
    <keybind key="XF86AudioMute">
      <action name="Execute">
        <command>pactl set-sink-mute @DEFAULT_SINK@ toggle</command>
      </action>
    </keybind>
    <keybind key="XF86AudioMicMute">
      <action name="Execute">
        <command>pactl set-source-mute @DEFAULT_SOURCE@ toggle</command>
      </action>
    </keybind>
    <!-- Brightness control -->
    <keybind key="XF86MonBrightnessUp">
      <action name="Execute">
        <command>brightnessctl set +10%</command>
      </action>
    </keybind>
    <keybind key="XF86MonBrightnessDown">
      <action name="Execute">
        <command>brightnessctl set 10%-</command>
      </action>
    </keybind>

    <!-- Open Terminal -->
    <keybind key="C-A-t">
      <action name="Execute">
        <command>lxterminal</command>
      </action>
    </keybind>

    <!-- Open File Manager -->
    <keybind key="C-A-e">
      <action name="Execute">
        <command>pcmanfm</command>
      </action>
    </keybind>

    <!-- Super key toggle menu -->
    <keybind key="Super_L">
      <action name="Execute">
        <command>jgmenu_run</command>
      </action>
    </keybind>

    <!-- Shift+Super+S to Screenshot area -->
    <keybind key="S-W-s">
        <action name="Execute">
            <command>bash -c 'mkdir -p "$HOME/Pictures/Screenshots" && scrot --border --pointer --freeze --select --quality 100 "$HOME/Pictures/Screenshots/screenshot-%Y-%m-%d-%H%M%S.jpg"'</command>
        </action>
    </keybind>

    <!-- Shift+PrtSc to Screenshot -->
    <keybind key="S-Print">
        <action name="Execute">
            <command>bash -c 'mkdir -p "$HOME/Pictures/Screenshots" && scrot --border --pointer --quality 100 "$HOME/Pictures/Screenshots/screenshot-%Y-%m-%d-%H%M%S.jpg"'</command>
        </action>
    </keybind>

    <!-- Toggle Show Desktop -->
    <keybind key="C-W-d">
        <action name="ToggleShowDesktop"/>
    </keybind>

    <!-- Tile window Full -->
    <keybind key="C-W-z">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>0</x>
        <y>0</y>
        <width>100%</width>
        <height>100%</height>
      </action>
    </keybind>

    <!-- Tile window Maximized -->
    <keybind key="C-W-f">
        <action name="ToggleMaximize"/>
    </keybind>

    <!-- Tile window Full + gap -->
    <keybind key="C-W-e">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>center</x>
        <y>center</y>
        <width>94%</width>
        <height>91%</height>
      </action>
    </keybind>

    <!-- Tile window Left -->
    <keybind key="C-W-Left">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>0</x>
        <y>0</y>
        <width>50%</width>
        <height>100%</height>
      </action>
    </keybind>

    <!-- Tile window Right -->
    <keybind key="C-W-Right">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>-0</x>
        <y>0</y>
        <width>50%</width>
        <height>100%</height>
      </action>
    </keybind>

    <!-- Tile window Top -->
    <keybind key="C-W-Up">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>0</x>
        <y>0</y>
        <width>100%</width>
        <height>50%</height>
      </action>
    </keybind>

    <!-- Tile window Bottom -->
    <keybind key="C-W-Down">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>0</x>
        <y>-0</y>
        <width>100%</width>
        <height>50%</height>
      </action>
    </keybind>

    <!-- Tile window Top-Left -->
    <keybind key="C-W-q">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>0</x>
        <y>0</y>
        <width>50%</width>
        <height>50%</height>
      </action>
    </keybind>

    <!-- Tile window Top-Right -->
    <keybind key="C-W-w">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>-0</x>
        <y>0</y>
        <width>50%</width>
        <height>50%</height>
      </action>
    </keybind>

    <!-- Tile window Bottom-Left -->
    <keybind key="C-W-a">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>0</x>
        <y>-0</y>
        <width>50%</width>
        <height>50%</height>
      </action>
    </keybind>

    <!-- Tile window Bottom-Right -->
    <keybind key="C-W-s">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>-0</x>
        <y>-0</y>
        <width>50%</width>
        <height>50%</height>
      </action>
    </keybind>

      <!-- move window -->
      <!--
      <mousebind button="A-Left" action="Drag">
        <action name="Move"/>
      </mousebind>
      -->
      <mousebind button="C-W-Left" action="Drag">
        <action name="Move"/>
      </mousebind>

      <!-- resize window -->
      <!--
      <mousebind button="A-Right" action="Drag">
        <action name="Resize"/>
      </mousebind>
      -->
      <mousebind button="C-W-Right" action="Drag">
        <action name="Resize"/>
      </mousebind>

    <!-- Force Tint2 Bottom Stay Below Surface (Anti-Raise) -->
    <application name="tint2" class="Tint2">
      <layer>below</layer>
      <focus>no</focus>
    </application>

    <!-- Force Plank Always Floating Above Tint2 -->
    <application name="plank" class="Plank">
      <layer>above</layer>
      <focus>yes</focus>
    </application>

    <application class="X-terminal-emulator">
        <position force="yes">
            <x>center</x>
            <y>center</y>
        </position>
    </application>

    <application class="XTerm">
        <position force="yes">
            <x>center</x>
            <y>center</y>
        </position>
    </application>

    <application class="Lxterminal">
        <position force="yes">
            <x>center</x>
            <y>center</y>
        </position>
    </application>

    <application class="Pcmanfm">
        <position force="yes">
            <x>center</x>
            <y>center</y>
        </position>
    </application>
```

## Restart and refresh the Desktop
```
openbox --reconfigure
```

## Uncheck this in Default application for LXSession > autostart > Known Applications:
```
picom # or xcompmgr
network
bluetooth
Print Queue Applet (system-config-printer)
User folders update (xdg-user-dirs-gtk)
Power Manager
Diodon
xiccd
```

## Copy ```./.config/tint2/start-desktop.sh``` to ```~/.config/tint2/start-desktop.sh```

## Copy ```./.config/lxsession/LXDE/autostart``` to ```~/.config/lxsession/LXDE/autostart```

## Install [linux > themes > gtk2.md](https://github.com/willyhorizont/linux/blob/main/themes/gtk2.md)

## Apply Cursor theme globally
```
sudo update-alternatives --config x-cursor-theme
```

## Adjust notification settings in ```~/.config/dunst/dunstrc```

## create logout.desktop and lock.desktop:
```
## logout
lxsession-logout

## lock screen
lxlock
```

## Create Bottom Panel App Launcher desktop shortcut
```
mkdir -p ~/.local/share/applications
cat << 'EOF' > ~/.local/share/applications/bottom-panel-app-launcher.desktop
[Desktop Entry]
Name=Bottom Panel App Launcher
Comment=Bottom Panel App Launcher
Exec=jgmenu_run
Terminal=false
Type=Application
Icon=distributor-logo-debian
Categories=System;Utility;
EOF
```

## Create tui0-locker desktop shortcut
```
mkdir -p ~/.local/share/applications
cat << 'EOF' > ~/.local/share/applications/tui0-locker.desktop
[Desktop Entry]
Name=tui0-locker
Comment=tui0-locker
Exec=xterm -geometry 80x28 -bg black -fg white -fa Monospace -fs 8 -e ~/willyhorizont.github.io/linux/tui0-locker.sh
Terminal=false
Type=Application
Icon=system-lock-screen
Categories=Settings;
EOF
```

## Copy jgmenu to ~/.config

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
sudo apt purge -y lxpanel && sudo apt autoremove -y --purge

# Dictionary stuff
sudo apt purge -y goldendict-ng kasumi && sudo apt autoremove -y --purge

sudo apt purge -y lxtask && sudo apt autoremove -y --purge
sudo apt install -y btop
sudo apt purge -y mplayer && sudo apt autoremove -y --purge
sudo apt purge -y volumeicon-alsa fdpowermon && sudo apt autoremove -y --purge
sudo apt purge -y xsane sane-utils && sudo apt autoremove -y --purge
sudo apt purge -y system-config-printer system-config-printer-common && sudo apt autoremove -y --purge
sudo apt purge -y synaptic && sudo apt autoremove -y --purge
sudo apt install -y transmission-gtk
sudo apt purge -y deluge deluge-common deluge-gtk && sudo apt autoremove -y --purge

# Screen locker
sudo apt purge -y \
    light-locker \
    xscreensaver \
    gnome-screensaver \
    slock \
    suckless-tools \
    xlock \
    i3lock \
    slimlock \
    xsecurelock \
    && sudo apt autoremove -y --purge

mkdir -p ~/.local/share/applications
if [ -f /usr/share/applications/libreoffice-startcenter.desktop ]; then cp /usr/share/applications/libreoffice-startcenter.desktop ~/.local/share/applications/ && { if grep -q "^NoDisplay=" "$HOME/.local/share/applications/libreoffice-startcenter.desktop"; then sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$HOME/.local/share/applications/libreoffice-startcenter.desktop"; else sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$HOME/.local/share/applications/libreoffice-startcenter.desktop"; fi; }; fi
if [ -f /usr/share/applications/libreoffice-math.desktop ]; then cp /usr/share/applications/libreoffice-math.desktop ~/.local/share/applications/ && { if grep -q "^NoDisplay=" "$HOME/.local/share/applications/libreoffice-math.desktop"; then sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$HOME/.local/share/applications/libreoffice-math.desktop"; else sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$HOME/.local/share/applications/libreoffice-math.desktop"; fi; }; fi
if [ -f /usr/share/applications/libreoffice-draw.desktop ]; then cp /usr/share/applications/libreoffice-draw.desktop ~/.local/share/applications/ && { if grep -q "^NoDisplay=" "$HOME/.local/share/applications/libreoffice-draw.desktop"; then sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$HOME/.local/share/applications/libreoffice-draw.desktop"; else sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$HOME/.local/share/applications/libreoffice-draw.desktop"; fi; }; fi
if [ -f /usr/share/applications/btop.desktop ]; then cp /usr/share/applications/btop.desktop ~/.local/share/applications/ && { sed -i 's|^Exec=.*|Exec=xterm -geometry 80x28 -bg black -fg white -fa Monospace -fs 8 -e btop|; s|^Terminal=.*|Terminal=false|' "$HOME/.local/share/applications/btop.desktop"; }; fi
if [ -f /usr/share/applications/cmatrix.desktop ]; then cp /usr/share/applications/cmatrix.desktop ~/.local/share/applications/ && { sed -i 's|^Exec=.*|Exec=xterm -geometry 80x24 -bg black -fg white -fa Monospace -fs 8 -bc -uc -e cmatrix -s -u 10 -a|; s|^Terminal=.*|Terminal=false|' "$HOME/.local/share/applications/cmatrix.desktop"; }; fi
if [ -f /usr/share/applications/xterm.desktop ]; then cp /usr/share/applications/xterm.desktop ~/.local/share/applications/ && { sed -i 's|^Exec=.*|Exec=xterm -geometry 88x24 -bc -uc|; s|^Terminal=.*|Terminal=false|' "$HOME/.local/share/applications/xterm.desktop"; }; fi

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
sudo apt purge -y uim uim-gtk3 uim-mozc mozc-server mozc-data && sudo apt autoremove -y --purge
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
im-config -n none

sudo apt install -y xserver-xorg-input-all xserver-xorg-input-libinput libinput-bin
sudo apt install -y xserver-xorg-input-synaptics
```

## See [linux > cheatsheet > general.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/general.md)

## See [linux > cheatsheet > debian-apt.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/debian-apt.md)
