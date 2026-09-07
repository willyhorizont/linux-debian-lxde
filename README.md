# Debian+LXDE Post Install

1. Do [linux > post-install > debian-apt.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/debian-apt.md#a)

2. Reverse scroll and Turn on touchpad tapping
```
sudo mkdir -p /etc/X11/xorg.conf.d && echo -e 'Section "InputClass"\n    Identifier "touchpad catchall"\n    MatchIsTouchpad "on"\n    MatchDevicePath "/dev/input/event*"\n    Driver "libinput"\n    Option "NaturalScrolling" "true"\n    Option "Tapping" "on"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
```

3. Install packages
```
# Brightness control
sudo apt install brightnessctl -y

# Audio
sudo apt install pipewire-audio -y
sudo apt install pipewire-pulse -y
sudo apt install pulseaudio-utils -y

# Bluetooth
sudo apt install blueman -y

# Panel
sudo apt install xfce4-panel -y
sudo apt install xfce4-whiskermenu-plugin -y
sudo apt install xfce4-docklike-plugin -y
sudo apt install xfce4-pulseaudio-plugin -y
sudo apt install xfce4-power-manager-plugins -y
sudo apt install xfce4-genmon-plugin -y
sudo apt install xfce4-notifyd -y
```

4. Enable Audio
```
systemctl --user daemon-reload
systemctl --user --now enable pipewire pipewire-pulse wireplumber
```

5. Add keybinds -> open ```~/.config/openbox/lxde-rc.xml``` and add this:
```
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

    <!-- Super key toggle menu -->
    <keybind key="Super_L">
      <action name="Execute">
        <command>xfce4-popup-whiskermenu</command>
      </action>
    </keybind>
```

6. Restart and refresh the Desktop
```
openbox --reconfigure
```

7. Remove this from autostart:
```
@lxpanel
```

8. Add this to autostart:
```
xfce4-panel
```

9. (Optional) Install and enable Window Compositor for animations/transparencies/shadows/effects
```
sudo apt install picom -y
```

10. (Optional) Add this to autostart to Enable Window Compositor for animations/transparencies/shadows/effects:
```
picom -b
```

11. Install [linux > themes > gtk2.md](https://github.com/willyhorizont/linux/blob/main/themes/gtk2.md)

12. Apply Cursor theme globally
```
sudo update-alternatives --config x-cursor-theme
```

13. Do [linux > post-install > general.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/general.md#a)

14. Change lock screen
```
TODO
```

15. See [linux > cheatsheet > debian-apt.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/debian-apt.md)

16. See [linux > cheatsheet > general.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/general.md)

17. Adjust notification settings:
```
xfce4-notifyd-config
```
