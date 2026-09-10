#!/bin/bash

blueman-applet &

sleep 2

tint2 -c ~/.config/tint2/tint2-top &
tint2 -c ~/.config/tint2/tint2-bottom &
plank &

sleep 2
nm-applet &
