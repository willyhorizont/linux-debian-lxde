#!/bin/bash

openbox --reconfigure

killall -9 tint2 nm-applet blueman-applet plank

sleep 2

/home/willy/.config/tint2/launch_desktop.sh &
