#!/bin/bash

i3-msg workspace 1 && i3-msg 'exec code "$HOME/Codes/linux/"'
xdotool search --sync --onlyvisible --name "linux |"
i3-msg workspace 2 && i3-msg 'exec code "$HOME/Codes/linux-debian-lxde/"'
xdotool search --sync --onlyvisible --name "linux-debian-lxde |"
i3-msg workspace 3 && i3-msg 'exec brave-browser '
xdotool search --sync --onlyvisible --class "Brave-browser"
i3-msg workspace 4 && i3-msg 'exec pcmanfm "$HOME/Codes/linux-debian-lxde/.config/lxsession/LXDE/"'
i3-msg workspace 4 && i3-msg 'exec pcmanfm "$HOME/Codes/linux-debian-lxde/"'
i3-msg workspace 4 && i3-msg 'exec pcmanfm "$HOME/Codes/linux/"'
