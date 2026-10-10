#!/bin/sh

PID_DIR="$HOME/willyhorizont.github.io/pids"

TOP_BAR_PID=$(cat "$PID_DIR/tint2-top-bar.pid" 2>/dev/null)
BTM_PNL_PID=$(cat "$PID_DIR/tint2-bottom-panel.pid" 2>/dev/null)
PLNK_PID=$(cat "$PID_DIR/plank.pid" 2>/dev/null)

notify-send "Restarting Desktop..."

openbox --reconfigure

pkill -9 -f "$HOME/willyhorizont.github.io/linux-debian-lxde/start-desktop.sh" 2>/dev/null
pkill -9 -f "$HOME/willyhorizont.github.io/linux/blu-lght-fltr.sh" 2>/dev/null
pkill -9 -f "$HOME/willyhorizont.github.io/linux/lockerd.sh" 2>/dev/null

pkill -9 -f "xterm.*-name idle-window" 2>/dev/null
pkill -9 -f "xterm.*-name welcome-window" 2>/dev/null

pkill -9 -x "xpenguins" 2>/dev/null

[ -n "$TOP_BAR_PID" ] && kill -9 "$TOP_BAR_PID" 2>/dev/null
[ -n "$TOP_BAR_PID" ] && tail --pid="$TOP_BAR_PID" -f /dev/null 2>/dev/null
rm -f "$PID_DIR/tint2-top-bar.pid"

[ -n "$BTM_PNL_PID" ] && kill -9 "$BTM_PNL_PID" 2>/dev/null
[ -n "$BTM_PNL_PID" ] && tail --pid="$BTM_PNL_PID" -f /dev/null 2>/dev/null
rm -f "$PID_DIR/tint2-bottom-panel.pid"

[ -n "$PLNK_PID" ] && kill -9 "$PLNK_PID" 2>/dev/null
[ -n "$PLNK_PID" ] && tail --pid="$PLNK_PID" -f /dev/null 2>/dev/null
rm -f "$PID_DIR/plank.pid"

setsid bash -c "$HOME/willyhorizont.github.io/linux-debian-lxde/start-desktop.sh" >/dev/null 2>&1 &
