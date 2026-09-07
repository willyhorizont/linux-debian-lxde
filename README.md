# Debian+LXDE Post Install

1. Do linux > post-install > debian-apt.md > A

2. Reverse scroll
```
sudo mkdir -p /etc/X11/xorg.conf.d && echo -e 'Section "InputClass"\n    Identifier "touchpad catchall"\n    MatchIsTouchpad "on"\n    MatchDevicePath "/dev/input/event*"\n    Driver "libinput"\n    Option "NaturalScrolling" "true"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
```

3. Turn on tap touchpad
```
sudo sed -i '/Driver "libinput"/a \    Option "Tapping" "on"' /etc/X11/xorg.conf.d/30-touchpad.conf
```

4. Brightness and Audio control
4.1.
```
sudo apt install brightnessctl pulseaudio-utils -y
```
4.2. open ```~/.config/openbox/lxde-rc.xml``` and add this:
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
```
4.3. Restart and refresh the Desktop
```
openbox --reconfigure
```

5. Install bluetooth
```
sudo apt install blueman -y
```

6. Turn on super key to open menu on startup

6.1.
```
sudo apt install jgmenu -y
```

6.2. open ```~/.config/openbox/lxde-rc.xml``` and add this:
```
    <!-- Super key toggle menu -->
    <keybind key="Super_L">
      <action name="Execute">
        <command>jgmenu_run</command>
      </action>
    </keybind>
```

6.3. Restart and refresh the Desktop
```
openbox --reconfigure
```

6.4. open ```~/.config/jgmenu/jgmenurc``` and adjust this:
```
menu_margin_x = 0
menu_margin_y = 24

color_menu_bg = #ffffff
color_menu_bg_to = #ffffff
color_menu_border = #cccccc
color_norm_bg = #ffffff
color_norm_fg = #333333
color_sel_bg = #e0e0e0
color_sel_fg = #000000
```

6.5. Create appmenu-jgmenu.desktop
```
echo -e "[Desktop Entry]\nVersion=1.0\nType=Application\nName=App Menu\nComment=App Menu\nExec=jgmenu_run\nIcon=/usr/share/icons/Papirus/16x16/apps/distributor-logo-debian.svg\nTerminal=false\nCategories=System;\nStartupNotify=false" > ~/.local/share/applications/appmenu-jgmenu.desktop
update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications
```

6.6. Create separator.desktop
```
echo -e "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Separator\nComment=Separator\nExec=true\nIcon=/usr/share/icons/Papirus/16x16/symbolic/apps/separator-symbolic.svg\nTerminal=false\nCategories=System;\nStartupNotify=false" > ~/.local/share/applications/separator.desktop
update-desktop-database ~/.local/share/applications && sudo update-desktop-database /usr/share/applications
```

7. Install linux > themes > gtk2.md

8. Apply Cursor theme globally
```
sudo update-alternatives --config x-cursor-theme
```

9. Do linux > post-install > general.md > A

10. Change lock screen
```
TODO
```

11. See linux > cheatsheet > debian-apt.md
