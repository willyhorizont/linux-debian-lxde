# Debian LXDE Post Install

![Debian LXDE Screenshot](https://github.com/willyhorizont/linux-debian-lxde/blob/main/screenshot.jpg)  

1. Reverse scroll and Turn on touchpad tapping
```
sudo mkdir -p /etc/X11/xorg.conf.d && echo -e 'Section "InputClass"\n    Identifier "touchpad catchall"\n    MatchIsTouchpad "on"\n    MatchDevicePath "/dev/input/event*"\n    Driver "libinput"\n    Option "NaturalScrolling" "true"\n    Option "Tapping" "on"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
```

2. Do [linux > post-install > general.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/general.md#a)

3. Do [linux > post-install > debian-apt.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/debian-apt.md#a)

4. Install packages
```
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
    picom \
    tint2 \
    plank \
    jgmenu \
    power-profiles-daemon \
    acpi \
    xdotool \
    dunst \
    libnotify-bin \
    ""
```

5. Enable Audio
```
systemctl --user daemon-reload
systemctl --user --now enable pipewire pipewire-pulse wireplumber
```

6. Add keybinds -> open ```~/.config/openbox/lxde-rc.xml``` and add this:
```xml
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

    <!-- Super+Shift+S to Screenshot area -->
    <keybind key="W-S-s">
      <action name="Execute">
        <command>bash -c 'gnome-screenshot --area --include-pointer --clipboard --file ~/Pictures/Screenshots/screenshot-$(date +%Y-%m-%d_%H%M%S).jpg'</command>
      </action>
    </keybind>

    <!-- Shift+PrtSc to Screenshot -->
    <keybind key="S-Print">
      <action name="Execute">
          <command>bash -c 'gnome-screenshot --include-pointer --clipboard --file ~/Pictures/Screenshots/screenshot-$(date +%Y-%m-%d_%H%M%S).jpg'</command>
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

    <!-- Tile window Full + gap -->
    <keybind key="C-W-e">
      <action name="Unmaximize"/>
      <action name="MoveResizeTo">
        <x>center</x>
        <y>center</y>
        <width>99%</width>
        <height>98%</height>
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
```

7. Restart and refresh the Desktop
```
openbox --reconfigure
```

8. Uncheck this in Default application for LXSession > autostart > Known Applications:
```
picom
network
bluetooth
Print Queue Applet (system-config-printer)
User folders update (xdg-user-dirs-gtk)
Power Manager
Diodon
xiccd
```

9. Copy ```./.config/tint2/start-desktop.sh``` to ```~/.config/tint2/start-desktop.sh```

10. Copy ```./.config/lxsession/LXDE/autostart``` to ```~/.config/lxsession/LXDE/autostart```

11. Install [linux > themes > gtk2.md](https://github.com/willyhorizont/linux/blob/main/themes/gtk2.md)

12. Apply Cursor theme globally
```
sudo update-alternatives --config x-cursor-theme
```

13. Adjust notification settings in ```~/.config/dunst/dunstrc```

14. create logout.desktop and lock.desktop:
```
# logout
lxsession-logout

# lock screen
lxlock
```

15. Create Bottom Panel App Launcher by running this code:
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

16. Copy jgmenu to ~/.config

17. Setup App Tray -> run ```sudo mousepad /usr/share/plank/themes/Transparent/dock.theme``` and change ```BottomPadding=2``` to:
```
BottomPadding=0
LaunchBounceTime=0
```

18. Change lock screen
```
# install lock screen settings
sudo apt install -y lightdm-gtk-greeter-settings

# copy image to:
/usr/share/images/

# change lock screen clock format to:
%a, %d %b %Y | %I:%M:%S %p

# remove lock screen settings
sudo apt purge -y lightdm-gtk-greeter-settings && sudo apt autoremove -y --purge
```

19. Adjust default terminal:
```
sudo update-alternatives --config x-terminal-emulator
```

20. Remove unused packages:
```
sudo apt purge -y lxpanel && sudo apt autoremove -y --purge
sudo apt purge -y xiterm+thai && sudo apt autoremove -y --purge
sudo apt purge -y goldendict-ng && sudo apt autoremove -y --purge
sudo apt purge -y kasumi && sudo apt autoremove -y --purge
sudo apt purge -y volumeicon-alsa fdpowermon && sudo apt autoremove -y --purge
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
sudo apt purge -y fcitx* && sudo apt autoremove -y --purge
```

21. See [linux > cheatsheet > general.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/general.md)

22. See [linux > cheatsheet > debian-apt.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/debian-apt.md)
