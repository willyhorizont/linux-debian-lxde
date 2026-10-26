# IPC (Inter-Process Communication) sort by lightness

## lxde/openbox

1. xprop -root -spy _NET_CURRENT_DESKTOP
```sh
xprop -root -spy _NET_CURRENT_DESKTOP | while read -r _; do
    echo "Workspace changed!"
done
```

2. libwnck gi.repository Wnck
```py
import gi
gi.require_version('Wnck', '3.0')
from gi.repository import Wnck, GLib

def on_workspace_changed(screen, previously_active):
    print(f"cur_wrkspc: {screen.get_active_workspace().get_number() + 1}")

screen = Wnck.Screen.get_default()
screen.connect("active-workspace-changed", on_workspace_changed)
GLib.MainLoop().run()
```

3. xev -root -event property | grep --line-buffered "_NET_CURRENT_DESKTOP"
```sh
xev -root -event property | grep --line-buffered "_NET_CURRENT_DESKTOP" | while read -r _; do
    echo "Workspace changed!"
done
```

4. xdotool search --onlyvisible
```sh
xdotool search --onlyvisible . behave %@ focus exec bash -c 'killall -0 wmctrl &>/dev/null && echo "trigger"' 2>/dev/null | while read -r _; do
    echo "Workspace changed!"
done
```

## i3 i3wm i3/ipc-socket

1. internal/i3 (polybar)

2. i3-msg -m -t subscribe
```sh
i3-msg -m -t subscribe '["workspace"]' | while read -r _; do
    echo "Workspace changed!"
done
```
```sh
i3-msg -t subscribe '["workspace"]' | while read -r event; do
    cur_wrkspc=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
    echo "Workspace changed!"
done
```

3. Native i3IPC (i3ipc-python i3status-rust i3ipc++ i3/ipc.h quicki3ipc i3ipc-rs i3ipc-go i3-ipc i3wm-ipc i3ipc-lua i3ipc-perl)
```py
from i3ipc import Connection

def on_workspace_change(i3, event):
    if event.change in ['focus', 'init', 'empty']:
        print(f"Workspace aktif sekarang changed!")

i3 = Connection()
i3.on('workspace', on_workspace_change)
i3.main()
```

4. xprop -root -spy _NET_CURRENT_DESKTOP
5. xdotool search --onlyvisible
