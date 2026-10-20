# i3 trial

# i3 not working
* pcmanfm --desktop for desktop icon
* pcmanfm --desktop for desktop walpaper, replace with feh
* tint2-top-bar
* tint2-bottom-panel, even shrink right workaround is not working
* plank shrink bottom left
* tux xpenguins
* welcome-window idle-window

## i3 working
* dmn-lockr

## dev version
```
v="0.5.3"; mkdir -p "$v" && cd "$v" && git clone --branch "$v" --depth 1 https://github.com/willyhorizont/linux-debian-lxde.git . && cd ../
```

## bottom panel
1. polybar + i3-workspaces / i3 IPC (Inter-Process Communication) Socket + tint2
2. lemonbar + i3-workspaces / i3 IPC (Inter-Process Communication) Socket + tint2
3. dzen2 + i3-workspaces / i3 IPC (Inter-Process Communication) Socket + tint2
```
i3-msg -t subscribe '["workspace"]' | while read -r event; do
    cur_wrkspc=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
    # ...
done
```
4. xfce4-panel + xfce4-i3-workspaces-plugin + \
    xfce4-whiskermenu-plugin + \
    xfce4-docklike-plugin + \
    xfce4-genmon-plugin + \
    xfce4-pulseaudio-plugin + \
    xfce4-power-manager-plugins + \
    xfce4-notifyd + \
    ""
<!-- 5. lb_panel any + rb_panel lxpanel -->
<!-- exec_always --no-startup-id pkill -x lxpanel; lxpanel -->
<!-- 6. lb_panel any + rb_panel mate-panel -->
<!-- exec_always --no-startup-id pkill -x mate-panel; mate-panel -->
