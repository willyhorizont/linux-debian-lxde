#!/bin/bash

openbox --reconfigure

killall -9 tint2 plank

sleep 2

/home/willy/.config/tint2/start-desktop.sh &
