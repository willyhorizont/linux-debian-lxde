# Debian LXDET2P (Tint2+Plank) Post Install

![Debian LXDET2P (Tint2+Plank) Screenshot](https://github.com/willyhorizont/linux-debian-lxde/blob/main/alternative-version/screenshot.jpg)  

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
sudo apt install picom -y
sudo apt install tint2 -y
sudo apt install plank -y
sudo apt install jgmenu -y
sudo apt install volumeicon-alsa -y
sudo apt install fdpowermon -y
sudo apt install acpi -y
sudo apt install xdotool -y
sudo apt install dunst -y
sudo apt install libnotify-bin -y
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
      <command>jgmenu_run</command>
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

9. Copy ```launch-desktop.sh``` to ``````~/.config/tint2/```

10. Replace ```~/.config/lxsession/LXDE/autostart``` with this:
```
@picom --backend xrender -b
# @lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
# @xscreensaver -no-splash
@dunst
@/home/yourusername/.config/tint2/launch-desktop.sh
```

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

15. Setup Top Bar:
```
cat << 'EOF' > ~/.config/tint2/tint2-top
panel_items = EFEFE
panel_position = top center horizontal
panel_layer = top
panel_size = 100% 20
panel_margin = 0 0
panel_padding = 0 0 0
strut_policy = follow_size

background_id = 1
background_color = #000000 100
border_color = #000000 0
border_width = 0
border_radius = 0
border_sides = top bottom left right

panel_background_id = 1

# --- E1: SPRM ---
execp = new
execp_command = $HOME/Codes/linux/SPRM.pl
execp_interval = 1
execp_has_icon = 0
execp_font = Monospace 8
execp_font_color = #FF1493 100
execp_padding = 4 0

# --- E2: WhoAmI ---
execp = new
execp_command = echo "willyhorizont.github.io"
execp_interval = 0
execp_font = Monospace 8
execp_font_color = #FF1493 100
execp_padding = 4 0

# --- E3: SuckMyClock ---
execp = new
execp_command = $HOME/Codes/linux/SuckMyClock.pl
execp_interval = 1
execp_has_icon = 0
execp_font = Monospace 8
execp_font_color = #FF1493 100
execp_padding = 4 0
EOF
```

16. Setup Bottom Panel:
```
mkdir -p ~/.config/tint2
cat << 'EOF' > ~/.config/tint2/tint2-bottom
panel_items = LFSEEEEP
panel_position = bottom center horizontal
panel_layer = bottom
panel_size = 100% 36
panel_margin = 0 0
panel_padding = 4 2 4
wm_menu = 1
strut_policy = follow_window

# --- BACKGROUND 1 ---
background_id = 1
background_color = #ffffff 100
border_color = #dcdcdc 100
border_width = 1
border_radius = 0
border_sides = top bottom left right
panel_background_id = 1

# --- L: App Launcher ---
launcher_padding = 4 4
launcher_background_id = 0
launcher_icon_size = 24
launcher_icon_theme = Papirus
launcher_icon_theme_override = 1
launcher_item_app = ~/.local/share/applications/jgmenu-custom.desktop

# --- S: Systray ---
systray_padding = 4 2 4
systray_background_id = 0
systray_sort = left2right
systray_icon_size = 20

# --- E1: Indicator Audio Volume ---
execp = new
execp_command = echo "🔊 $(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1)"
execp_interval = 1
execp_has_icon = 0
execp_font = Sans 10
execp_font_color = #000000 100
execp_padding = 6 0
execp_lclick_command = lxterminal -e alsamixer

# --- E2: Indicator Battery ---
execp = new
execp_command = echo "🔋 $(acpi -b | awk -F', ' '{print $2}' | tr -d '\n')"
execp_interval = 5
execp_has_icon = 0
execp_font = Sans 10
execp_font_color = #000000 100
execp_padding = 6 0

# --- E3: Indicator Notification ---
execp = new
execp_command = echo "🔔"
execp_interval = 0
execp_has_icon = 0
execp_font = Sans 10
execp_font_color = #000000 100
execp_padding = 6 0
execp_lclick_command = dunstctl history-pop

# --- P: Button to Toggle Show Desktop ---
button = new
button_text = _
button_font = Sans 10
button_font_color = #000000 100
button_lclick_command = xdotool key ctrl+super+d
button_padding = 6 0
button_background_id = 0
EOF
```

17. Create Bottom Panel App Launcher by running this code:
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

mkdir -p ~/.config/jgmenu
cat << 'EOF' > ~/.config/jgmenu/jgmenurc
# --- Positioning ---
menu_margin_x = 0
menu_margin_y = 36
menu_padding_top = 4
menu_padding_right = 4
menu_padding_bottom = 4
menu_padding_left = 4
menu_halign = left
menu_valign = bottom

# --- Base Theming ---
color_menu_bg = #ffffff 100
color_menu_border = #dcdcdc 100
color_norm_fg = #000000 100
color_norm_bg = #ffffff 0

# --- Theming When Active/Hover ---
color_sel_fg = #000000 100
color_sel_bg = #e0e0e0 100
color_sel_border = #cccccc 100

# --- Theming Font ---
font = Sans 10
icon_theme = Papirus-Light
item_height = 28
EOF

cat << 'EOF' > ~/.config/jgmenu/prepend.csv
Terminal,lxterminal,utilities-terminal
File Manager,pcmanfm,system-file-manager
Firefox Web Browser,firefox-esr,firefox-esr
EOF

cat << 'EOF' > ~/.config/jgmenu/append.csv
Lock Screen,lxlock,system-lock-screen
Logout,lxsession-logout,system-log-out
EOF
```

18. Setup App Tray -> run ```sudo mousepad /usr/share/plank/themes/Transparent/dock.theme``` and change ```BottomPadding=2``` to ```BottomPadding=0```

19. Change lock screen
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

20. Adjust default terminal:
```
sudo update-alternatives --config x-terminal-emulator
```

21. Remove unused packages:
```
sudo apt purge xiterm+thai -y && sudo apt autoremove -y
sudo apt purge lxpanel -y && sudo apt autoremove -y
```

22. See [linux > cheatsheet > general.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/general.md)

23. See [linux > cheatsheet > debian-apt.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/debian-apt.md)
