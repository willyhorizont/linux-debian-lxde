#!/bin/bash

# repo="linux-debian-lxde"; v="0.5.9"; pv="$HOME/Codes/dev/$v"; mkdir -p "$pv" && cd "$pv" && git clone --branch "$v" --depth 1 "https://github.com/willyhorizont/$repo.git" . && cd ../
# repo="linux"; v="0.5.5"; pv="$HOME/Codes/dev/$repo-$v"; mkdir -p "$pv" && cd "$pv" && git clone --branch "$v" --depth 1 "https://github.com/willyhorizont/$repo.git" . && cd ../
repo="linux-debian-lxde"; v="0.5.5"; pv="$HOME/Codes/dev/$repo-$v"; mkdir -p "$pv" && cd "$pv" && git clone --branch "$v" --depth 1 "https://github.com/willyhorizont/$repo.git" . && cd ../
