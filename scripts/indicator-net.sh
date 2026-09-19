#!/bin/bash

CON_TYPE=$(nmcli -t -f TYPE,STATE dev | grep -w "connected" | head -n1 | cut -d: -f1)
if [ "$CON_TYPE" = "ethernet" ]; then
    echo "[net=ethernet ]"
elif [ "$CON_TYPE" = "wifi" ]; then
    WIFI_INFO=$(nmcli -t -f active,ssid,signal dev wifi | grep '^yes:')
    SIG=$(echo "$WIFI_INFO" | cut -d: -f3)
    SIG_PAD=$(printf "%3d" "$SIG")
    echo "[net=wifi $SIG_PAD%]"
else
    echo "[net=x        ]"
fi
