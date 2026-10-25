#!/bin/bash

case 0 in
    $(pgrep -x "i3" >/dev/null; echo $?))
        CURRENT_SESSION="i3"
        ;;
    $(pgrep -x "lxsession" >/dev/null; echo $?))
        CURRENT_SESSION="lxde"
        ;;
    $(pgrep -x "openbox" >/dev/null; echo $?))
        CURRENT_SESSION="openbox"
        ;;
    *)
        CURRENT_SESSION="unknown"
        ;;
esac

echo "$CURRENT_SESSION"
