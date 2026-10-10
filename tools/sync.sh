#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
rm -rf "$HOME/willyhorizont.github.io/linux-debian-lxde"
mkdir -p "$HOME/willyhorizont.github.io/linux-debian-lxde/"
# cp -r . "$HOME/willyhorizont.github.io/linux-debian-lxde/"
cp -r "$RD/." "$HOME/willyhorizont.github.io/linux-debian-lxde/"
pkill -9 -f "$HOME/willyhorizont.github.io/linux-debian-lxde/restart-desktop.sh" 2>/dev/null
pkill -9 -f "$HOME/willyhorizont.github.io/linux-debian-lxde/install.sh" 2>/dev/null
setsid bash -c "$HOME/willyhorizont.github.io/linux-debian-lxde/install.sh" >/dev/null 2>&1 &
clear
