# Debian LXfcDE (LXDE+Xfce) Post Install

![Debian LXfcDE (LXDE+Xfce) Screenshot](https://github.com/willyhorizont/linux-debian-lxde/blob/main/screenshot.jpg)  

1. Reverse scroll and Turn on touchpad tapping
```
sudo mkdir -p /etc/X11/xorg.conf.d && echo -e 'Section "InputClass"\n    Identifier "touchpad catchall"\n    MatchIsTouchpad "on"\n    MatchDevicePath "/dev/input/event*"\n    Driver "libinput"\n    Option "NaturalScrolling" "true"\n    Option "Tapping" "on"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
```

2. Do [linux > post-install > general.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/general.md#a)

3. Do [linux > post-install > debian-apt.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/debian-apt.md#a)

4. Install packages
```
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
    xfce4-panel \
    xfce4-whiskermenu-plugin \
    xfce4-docklike-plugin \
    xfce4-pulseaudio-plugin \
    xfce4-power-manager-plugins \
    xfce4-genmon-plugin \
    xfce4-notifyd \
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
        <command>pactl set-sink-volume @DEFAULT_SINK@ +5%</command>
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
        <command>xfce4-popup-whiskermenu</command>
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

9. Replace ```~/.config/lxsession/LXDE/autostart``` with this:
```
# @lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
# @xscreensaver -no-splash
@xfce4-panel
```

10. Install [linux > themes > gtk2.md](https://github.com/willyhorizont/linux/blob/main/themes/gtk2.md)

11. Apply Cursor theme globally
```
sudo update-alternatives --config x-cursor-theme
```

12. Adjust notification settings:
```
xfce4-notifyd-config
```

13. Change menu icon panel button size, make it bigger -> open ```mousepad ~/.config/gtk-3.0/gtk.css``` and add this:
```
#whiskermenu-button image {
    -gtk-icon-transform: scale(1.4);
}
```

14. whiskermenu > commands:
```
# logout
lxsession-logout

# lock screen
lxlock
```

15. Change lock screen
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

16. Adjust default terminal:
```
sudo update-alternatives --config x-terminal-emulator
```

17. Remove unused packages:
```
sudo apt purge -y lxpanel && sudo apt autoremove -y --purge
sudo apt purge -y xiterm+thai && sudo apt autoremove -y --purge
sudo apt purge -y goldendict-ng && sudo apt autoremove -y --purge
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
```

18. See [linux > cheatsheet > general.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/general.md)

19. See [linux > cheatsheet > debian-apt.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/debian-apt.md)
