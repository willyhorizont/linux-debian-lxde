#!/bin/bash

pkill -x lxterminal
pkill -x xterm
pkill -x urxvt
pkill -x alacritty

# lxterminal -e bash -c "fastfetch; exec bash" &
# alacritty --option window.dimensions.lines=54 -e bash -c "fastfetch; exec bash" &
# xterm -bc -uc -u8 -fa Monospace -fs 8 -e bash -c "fastfetch; exec bash" &
# urxvt -bc -uc -pt root -fn "xft:Monospace:size=8" -e bash -c "fastfetch; exec bash" &

lxterminal -e btop &
# alacritty --option window.dimensions.lines=54 -e btop &
# xterm -bc -uc -u8 -fa Monospace -fs 8 -e btop &
# urxvt -bc -uc -pt root -fn "xft:Monospace:size=8" -e btop &
