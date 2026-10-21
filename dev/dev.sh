#!/bin/bash

v="0.5.9"; pv="$HOME/Codes/dev/$v" && mkdir -p "$pv" && cd "$pv" && git clone --branch "$v" --depth 1 https://github.com/willyhorizont/linux-debian-lxde.git . && cd ../
