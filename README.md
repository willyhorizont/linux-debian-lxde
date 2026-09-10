# Debian LXfcDE (LXDE+Xfce) Post Install

![Debian LXfcDE (LXDE+Xfce) Screenshot](https://github.com/willyhorizont/linux-debian-lxde/blob/main/screenshot.jpg)  

1. Do [linux > post-install > general.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/general.md#a)

2. Do [linux > post-install > debian-apt.md > A](https://github.com/willyhorizont/linux/blob/main/post-install/debian-apt.md#a)

3. Reverse scroll and Turn on touchpad tapping
```
sudo mkdir -p /etc/X11/xorg.conf.d && echo -e 'Section "InputClass"\n    Identifier "touchpad catchall"\n    MatchIsTouchpad "on"\n    MatchDevicePath "/dev/input/event*"\n    Driver "libinput"\n    Option "NaturalScrolling" "true"\n    Option "Tapping" "on"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
```

4. Install packages
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

5. Enable Audio
```
systemctl --user daemon-reload
systemctl --user --now enable pipewire pipewire-pulse wireplumber
```

6. Add keybinds -> open ```~/.config/openbox/lxde-rc.xml``` and add this:
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

  <!-- Toggle Show Desktop -->
  <keybind key="C-W-d">
      <action name="ToggleShowDesktop"/>
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

    <!-- Super + Alt + LMB to move window -->
    <!--
    <mousebind button="A-Left" action="Drag">
      <action name="Move"/>
    </mousebind>
    -->
    <mousebind button="W-A-Left" action="Drag">
      <action name="Move"/>
    </mousebind>

    <!-- Super + Alt + RMB to resize window -->
    <!--
    <mousebind button="A-Right" action="Drag">
      <action name="Resize"/>
    </mousebind>
    -->
    <mousebind button="W-A-Right" action="Drag">
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
sudo apt install lightdm-gtk-greeter-settings -y

# copy image to:
/usr/share/images/

# change lock screen clock format to:
%a, %d %b %Y | %I:%M:%S %p

# remove lock screen settings
sudo apt purge lightdm-gtk-greeter-settings -y && sudo apt autoremove -y
```

16. Adjust default terminal:
```
sudo update-alternatives --config x-terminal-emulator
```

17. Remove unused packages:
```
sudo apt purge xiterm+thai -y && sudo apt autoremove -y
sudo apt purge lxpanel -y && sudo apt autoremove -y
```

18. See [linux > cheatsheet > general.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/general.md)

19. See [linux > cheatsheet > debian-apt.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/debian-apt.md)
