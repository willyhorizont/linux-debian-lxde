# Debian LXDE Post Install

![Debian LXDE Screenshot](https://github.com/willyhorizont/linux-debian-lxde/blob/main/screenshot.jpg)  

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
sudo apt install tint2 -y
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
```

7. Restart and refresh the Desktop
```
openbox --reconfigure
```

8. comment out this from ```~/.config/lxsession/LXDE/autostart```:
```
@lxpanel
@xscreensaver
```

9. Add this to ```~/.config/lxsession/LXDE/autostart```:
```
@tint2
@dunst
@blueman-applet
@sh -c "sleep 1 && nm-applet"
```

12. Install [linux > themes > gtk2.md](https://github.com/willyhorizont/linux/blob/main/themes/gtk2.md)

13. Apply Cursor theme globally
```
sudo update-alternatives --config x-cursor-theme
```

14. Adjust notification settings in ```~/.config/dunst/dunstrc```

15. create logout.desktop and lock.desktop:
```
# logout
lxsession-logout

# lock screen
lxlock
```

16. Setup panel:
```
mkdir -p ~/.config/tint2
cat << 'EOF' > ~/.config/tint2/tint2rc
#-------------------------------------
# L -> T -> S -> (E1: Audio) -> (E2: Battery) -> (E3: Notification) -> (P: Show Desktop)
#-------------------------------------
panel_items = LTSEEEP
panel_position = bottom center horizontal
panel_layer = top
panel_size = 100% 36
panel_margin = 0 0
panel_padding = 4 2 4
wm_menu = 1

# --- BACKGROUND 1 (SOLID WHITE MAIN PANEL) ---
background_id = 1
background_color = #ffffff 100
border_color = #dcdcdc 100
border_width = 1
border_radius = 0
border_sides = top bottom left right

# --- BACKGROUND 2 (GREY ACTIVE TASKBAR) ---
background_id = 2
background_color = #e0e0e0 100
border_color = #cccccc 100
border_width = 1
border_radius = 2
border_sides = top bottom left right

# Apply Solid White Background
panel_background_id = 1

# --- L: Menu Button Launcher ---
launcher_padding = 4 0
launcher_background_id = 0
launcher_icon_size = 24
launcher_item_app = /usr/share/applications/jgmenu.desktop

# --- T: Unified App Tray (Pinned + Opened) ---
taskbar_mode = single_desktop
taskbar_hide_if_empty = 0
taskbar_padding = 6 0 6
task_icon = 1
task_text = 0
task_centered = 0
task_maximum_size = 40 32
taskbar_sort_order = application
task_launcher = 1
task_always_grouped = 1
task_background_id = 0
task_active_background_id = 2

# --- S: Systray (Bluetooth & Wifi) ---
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

# --- P: Button to Show Desktop ---
button = new
button_text = ▊
button_font = Sans 10
button_font_color = #000000 100
button_lclick_command = xdotool key Alt+d
button_padding = 6 0
button_background_id = 0
EOF
```

17. Change lock screen
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

18. Adjust default app:
```
sudo update-alternatives --config x-terminal-emulator
```

19. Remove unused packages:
```
sudo apt purge xiterm+thai -y && sudo apt autoremove -y
sudo apt purge lxpanel -y && sudo apt autoremove -y
```

20. See [linux > cheatsheet > debian-apt.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/debian-apt.md)

21. See [linux > cheatsheet > general.md](https://github.com/willyhorizont/linux/blob/main/cheatsheet/general.md)
