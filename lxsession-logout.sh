#!/bin/sh

ACTION=""

for arg in "$@"; do
    case "$arg" in
        --lock)     ACTION="lock" ;;
        --logout)   ACTION="logout" ;;
        --suspend)  ACTION="suspend" ;;
        --reboot)   ACTION="reboot" ;;
        --shutdown) ACTION="shutdown" ;;
        *) ;;
    esac
done

if [ -n "$ACTION" ]; then
    HIDE_ARGS="--hide-button hibernate --hide-button switch_user"
    [ "$ACTION" != "lock" ]     && HIDE_ARGS="$HIDE_ARGS --hide-button lock_screen"
    [ "$ACTION" != "logout" ]   && HIDE_ARGS="$HIDE_ARGS --hide-button logout"
    [ "$ACTION" != "suspend" ]  && HIDE_ARGS="$HIDE_ARGS --hide-button suspend"
    [ "$ACTION" != "reboot" ]   && HIDE_ARGS="$HIDE_ARGS --hide-button reboot"
    [ "$ACTION" != "shutdown" ] && HIDE_ARGS="$HIDE_ARGS --hide-button shutdown"
    lxsession-logout -p "$(printf '%0.s ' $(seq 1 80))" $HIDE_ARGS &

    WID_TARGET=""

    while true; do
        WID_TARGET=$(wmctrl -l -x -G | awk '$7 == "lxsession-logout.Lxsession-logout" && $9 == "lxsession-logout" {print $1}' 2>/dev/null)
        if [ -n "$WID_TARGET" ]; then
            break
        fi
        sleep 0.2
    done

    xdotool windowactivate --sync "$WID_TARGET"
    # wmctrl -i -a "$WID_TARGET"

    sleep 0.2

    xdotool key "Return"
else
    lxsession-logout -p "$(printf '%0.s ' $(seq 1 80))" \
        --hide-button hibernate \
        --hide-button switch_user \
        ""
fi
