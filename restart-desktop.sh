#!/bin/sh

notify-send "Restarting Desktop..."

pkill -f "tuxd.sh"
pkill -x xterm
pkill -x xpenguins

openbox --reconfigure

lxsession -r >/dev/null 2>&1 &

exit 0
