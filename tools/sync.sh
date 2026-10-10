#!/bin/bash

SD=$(dirname "$(realpath "$0")")
RD=$(realpath "$SD/..")
rm -rf "$HOME/willyhorizont.github.io/linux-debian-lxde"
mkdir -p "$HOME/willyhorizont.github.io/linux-debian-lxde/"
# cp -r . "$HOME/willyhorizont.github.io/linux-debian-lxde/"
cp -r "$RD/." "$HOME/willyhorizont.github.io/linux-debian-lxde/"
setsid bash -c "$HOME/willyhorizont.github.io/linux-debian-lxde/install.sh" >/dev/null 2>&1 &
clear
