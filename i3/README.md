# i3

![Debian LXDE i3 Screenshot 1](https://github.com/willyhorizont/linux-debian-lxde/blob/main/i3/screenshot1.jpg)  
![Debian LXDE i3 Screenshot 2](https://github.com/willyhorizont/linux-debian-lxde/blob/main/i3/screenshot2.jpg)  
![Debian LXDE i3 Screenshot 3](https://github.com/willyhorizont/linux-debian-lxde/blob/main/i3/screenshot3.jpg)  

## i3 not working
* pcmanfm --desktop for desktop icon
* pcmanfm --desktop for desktop walpaper, replace with feh
* tint2-top-bar
* tint2-bottom-panel, even shrink right workaround is not working
* plank shrink bottom left
* tux xpenguins
* welcome-window idle-window

## manual i3-workspaces / i3 IPC (Inter-Process Communication) Socket integration
```
i3-msg -t subscribe '["workspace"]' | while read -r event; do
    cur_wrkspc=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
    # ...
done
```

## bottom panel

### setup c
```
wallpaper = hsetroot
desktop_icons = none
file_manager = pcmanfm
app_menu = none
pinned_plus_opened_app_list = none
top_bar = tint2-top-bar
bottom_left_panel = polybar
bottom_right_panel = tint2-bottom-panel
workspaces = polybar + i3-workspaces / i3 IPC (Inter-Process Communication) Socket
indicator = tint2-bottom-panel

# polybar
position = root
width = 100%
content = i3-workspaces
visible = true
clickable = false
hoverable = false

# tint2-bottom-panel
position = overlay above polybar
width = 100%
content = indicator
visible = true
clickable = true
hoverable = true
```

### lemonbar + i3-workspaces / i3 IPC (Inter-Process Communication) Socket + tint2
### dzen2 + i3-workspaces / i3 IPC (Inter-Process Communication) Socket + tint2
### xfce4-panel + xfce4-i3-workspaces-plugin + \
    xfce4-whiskermenu-plugin + \
    xfce4-docklike-plugin + \
    xfce4-genmon-plugin + \
    xfce4-pulseaudio-plugin + \
    xfce4-power-manager-plugins + \
    xfce4-notifyd + \
    ""
<!-- ### lb_panel any + rb_panel lxpanel -->
<!-- exec_always --no-startup-id pkill -x lxpanel; lxpanel -->
<!-- ### lb_panel any + rb_panel mate-panel -->
<!-- exec_always --no-startup-id pkill -x mate-panel; mate-panel -->
i3bar + i3status
i3bar + i3blocks
i3bar + py3status
i3bar + i3status-rust (i3status-rs)
i3bar + bumblebee-status
xfce4-panel + i3wm
mate-panel + i3wm
