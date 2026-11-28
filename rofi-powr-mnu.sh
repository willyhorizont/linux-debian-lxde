#!/bin/bash

SCRIPT_NAME="rofi-powr-mnu.sh"
case "$DESKTOP_SESSION" in
    LXDE)
        CMD_LOGOUT="$HOME/willyhorizont.github.io/linux-debian-lxde/lxsession-logout.sh --logout"
        ;;
    openbox)
        CMD_LOGOUT="$HOME/willyhorizont.github.io/linux-debian-lxde/lxsession-logout.sh --logout"
        ;;
    i3)
        CMD_LOGOUT="i3-msg exit"
        ;;
    *)
        notify-send "[$SCRIPT_NAME]" "Unsupported DESKTOP_SESSION: '$DESKTOP_SESSION'"
        exit 1
        ;;
esac

CMD_LOCK="xtrlock"
DIRECT_ACTION=""

print_usage() {
    echo "Usage: $SCRIPT_NAME [--shutdown] [--reboot] [--suspend] [--logout] [--lock] [--btop]"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)     print_usage ;;
        --shutdown) DIRECT_ACTION="shutdown" ; shift ;;
        --reboot)   DIRECT_ACTION="reboot"   ; shift ;;
        --suspend)  DIRECT_ACTION="suspend"  ; shift ;;
        --logout)   DIRECT_ACTION="logout"   ; shift ;;
        --lock)     DIRECT_ACTION="lock"     ; shift ;;
        --btop)     DIRECT_ACTION="btop"     ; shift ;;
        *)          print_usage ;;
    esac
done

declare -A ALL_ACTIONS
ALL_ACTIONS=(
    ["shutdown"]="systemctl poweroff"
    ["reboot"]="systemctl reboot"
    ["suspend"]="systemctl suspend"
    ["logout"]="$CMD_LOGOUT"
    ["lock"]="$CMD_LOCK"
    ["btop"]="xfce4-terminal -e btop"
)

declare -A ALL_LABELS
ALL_LABELS=(
    ["btop"]="btop"
    ["lock"]="Lock"
    ["logout"]="Logout"
    ["suspend"]="Suspend"
    ["reboot"]="Reboot"
    ["shutdown"]="Shutdown"
)

declare -A ALL_ICONS
ALL_ICONS=(
    ["shutdown"]="system-shutdown"
    ["reboot"]="system-reboot"
    ["suspend"]="system-suspend"
    ["logout"]="system-log-out"
    ["lock"]="system-lock-screen"
    ["btop"]="utilities-system-monitor"
)

ORDERED_KEYS=(
    "btop"
    "lock"
    "logout"
    "suspend"
    "reboot"
    "shutdown"
)

if [ -n "$DIRECT_ACTION" ]; then
    ACTION_KEY="$DIRECT_ACTION"
else
    CHOICE=$( {
        for key in "${ORDERED_KEYS[@]}"; do
            DISPLAY_NAME="${ALL_LABELS[$key]}"
            ICON_NAME="${ALL_ICONS[$key]}"
            printf "%b\n" "${DISPLAY_NAME}\0icon\x1f${ICON_NAME}"
        done
    } | rofi -dmenu -p "$SCRIPT_NAME" -show-icons -i)

    if [ -z "$CHOICE" ]; then
        exit 0
    fi

    ACTION_KEY=""
    for key in "${!ALL_LABELS[@]}"; do
        if [[ "${ALL_LABELS[$key]}" == "$CHOICE" ]]; then
            ACTION_KEY="$key"
            break
        fi
    done
fi

if [ -z "${ALL_ACTIONS[$ACTION_KEY]}" ]; then
    notify-send "$SCRIPT_NAME" "Error: Invalid input!"
fi

if [[ "$ACTION_KEY" =~ ^(shutdown|reboot|suspend|logout)$ ]] && ! [[ "$CMD_LOGOUT" == *"lxsession-logout.sh --logout"* && "$ACTION_KEY" == "logout" ]]; then
    $HOME/willyhorizont.github.io/linux/confirm-cmd.sh --msg "Confirm ${ALL_LABELS[$ACTION_KEY]}" || exit 1
fi

exec sh -c "${ALL_ACTIONS[$ACTION_KEY]}"
