#!/bin/bash

openbox --reconfigure

killall -9 tint2 plank

sleep 2

~/linux-debian-lxde/scripts/start-desktop.sh &
