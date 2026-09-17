#!/bin/bash

echo "======================================="
echo "           NETWORK STATUS TUI          "
echo "======================================="

CON_TYPE=$(nmcli -t -f TYPE,STATE dev | grep -w "connected" | head -n1 | cut -d: -f1)

if [ "$CON_TYPE" = "ethernet" ]; then 
    echo " Connection Type : [ 🌐 Wired ]"
    echo " Network Status  : [ 🟢 Ethernet ]"
elif [ "$CON_TYPE" = "wifi" ]; then 
    WIFI_INFO=$(nmcli -t -f active,ssid,signal dev wifi | grep '^yes:')
    SSID=$(echo "$WIFI_INFO" | cut -d: -f2)
    SIG=$(echo "$WIFI_INFO" | cut -d: -f3)
    echo " Connection Type : [ 🛜 WiFi ]"
    echo " Network Status  : [ 🟢 $SSID $SIG% ]"
else 
    echo " Connection Type : [ 🌐 None ]"
    echo " Network Status  : [ 🔴 None ]"
fi

echo "======================================="
read -p "Press Enter to open nmtui..."

echo -e "\n[*] Launching nmtui..."
echo "---------------------------------------"

nmtui

echo "---------------------------------------"
read -n 1 -s -r -p "Press any key to close this window..."
echo ""
exit 0
