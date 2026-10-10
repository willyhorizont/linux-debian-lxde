#!/bin/sh

PID_DIR="$HOME/willyhorizont.github.io/pids"
mkdir -p "$PID_DIR"

(until pactl info >/dev/null 2>&1; do true; done && pactl set-source-mute @DEFAULT_SOURCE@ 1) >/dev/null 2>&1 &

plank &
echo $! > "$PID_DIR/plank.pid"
tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-bottom-panel" &
echo $! > "$PID_DIR/tint2-bottom-panel.pid"
tint2 -c "$HOME/willyhorizont.github.io/linux-debian-lxde/tint2-top-bar" &
echo $! > "$PID_DIR/tint2-top-bar.pid"
setsid bash -c "$HOME/willyhorizont.github.io/linux/lockerd.sh" >/dev/null 2>&1 &
bash -c "$HOME/willyhorizont.github.io/linux/blu-lght-fltr.sh" >/dev/null 2>&1 &
