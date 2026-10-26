#!/bin/sh

if [ -n "$DESKTOP_SESSION" ]; then
    case "$DESKTOP_SESSION" in
        lxde|LXDE)
            export XDG_CURRENT_DESKTOP="LXDE"
            ;;
        openbox|Openbox)
            export XDG_CURRENT_DESKTOP="openbox"
            ;;
        i3|i3wm)
            export XDG_CURRENT_DESKTOP="i3"
            ;;
    esac
fi
