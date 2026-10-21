#!/bin/sh

AUTO_CONFIRM=false
for arg in "$@"; do
    case "$arg" in
        -y)
            AUTO_CONFIRM=true
            ;;
        *)
            ;;
    esac
done

if [ "$AUTO_CONFIRM" = true ]; then
    lxsession-logout -p "$(printf '%0.s ' $(seq 1 80))" \
        --hide-button hibernate \
        --hide-button switch_user \
        --hide-button shutdown \
        --hide-button reboot \
        --hide-button suspend \
        --hide-button lock_screen \
        &

    WID_TARGET=""

    while true; do
        WID_TARGET=$(wmctrl -l -x -G | awk '$7 == "lxsession-logout.Lxsession-logout" && $9 == "lxsession-logout" {print $1}' 2>/dev/null)
        if [ -n "$WID_TARGET" ]; then
            break
        fi
        sleep 0.2
    done

    xdotool windowactivate --sync "$WID_TARGET"

    sleep 0.2

    xdotool key "Return"
else
    lxsession-logout -p "$(printf '%0.s ' $(seq 1 80))" \
        --hide-button hibernate \
        --hide-button switch_user \
        ""
fi
