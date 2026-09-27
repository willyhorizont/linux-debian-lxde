#!/bin/sh

openbox --reconfigure

killall -9 tint2 plank

sleep 2

~/willyhorizont.github.io/linux-debian-lxde/start-desktop.sh &
