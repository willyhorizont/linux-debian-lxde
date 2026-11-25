#!/bin/bash

SCRIPT_NAME="lxsession-logout.sh"
case "$DESKTOP_SESSION" in
    LXDE)
        ;;
    openbox)
        ;;
    *)
        notify-send "[$SCRIPT_NAME]" "Unsupported DESKTOP_SESSION: '$DESKTOP_SESSION'"
        exit 1
        ;;
esac

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

declare -A ALL_LABELS
ALL_LABELS=(
    ["lock"]="Lock"
    ["logout"]="Logout"
    ["suspend"]="Suspend"
    ["reboot"]="Reboot"
    ["shutdown"]="Shutdown"
)

if [ -n "$ACTION" ]; then
    if [ "$ACTION" = "shutdown" ] || [ "$ACTION" = "reboot" ] || [ "$ACTION" = "suspend" ] || [ "$ACTION" = "logout" ]; then
        if [ "$DESKTOP_SESSION" = "openbox" ]; then
            $HOME/willyhorizont.github.io/linux/confirm-cmd.sh --msg "Confirm ${ALL_LABELS[$ACTION]}" || exit 1
        fi
    fi
    if [ "$ACTION" = "logout" ] && [ "$DESKTOP_SESSION" = "openbox" ]; then
        openbox --exit
        exit 0
    fi
    HIDE_ARGS="--hide-button hibernate --hide-button switch_user"
    [ "$ACTION" != "lock" ]     && HIDE_ARGS="$HIDE_ARGS --hide-button lock_screen"
    [ "$ACTION" != "logout" ]   && HIDE_ARGS="$HIDE_ARGS --hide-button logout"
    [ "$ACTION" != "suspend" ]  && HIDE_ARGS="$HIDE_ARGS --hide-button suspend"
    [ "$ACTION" != "reboot" ]   && HIDE_ARGS="$HIDE_ARGS --hide-button reboot"
    [ "$ACTION" != "shutdown" ] && HIDE_ARGS="$HIDE_ARGS --hide-button shutdown"
    lxsession-logout -p "$(printf '%0.s ' $(seq 1 80))" $HIDE_ARGS &
else
    lxsession-logout -p "$(printf '%0.s ' $(seq 1 80))" \
        --hide-button hibernate \
        --hide-button switch_user \
        ""
fi
