#!/bin/bash

echo "======================================="
echo "          BLUETOOTH STATUS TUI         "
echo "======================================="

IS_AVAILABLE=$(ls /sys/class/bluetooth/ 2>/dev/null)
IS_POWERED=$(timeout 2 bluetoothctl show 2>/dev/null | grep 'Powered: yes')

if [ -z "$IS_AVAILABLE" ] || [ -z "$IS_POWERED" ]; then 
    echo " Power Status    : [ 🔴 OFF ]"
    echo " Connected Device: [ None ]"
else 
    echo " Power Status    : [ 🟢 ON ]"
    CONN_MAC=$(timeout 2 bluetoothctl devices Connected 2>/dev/null | awk '{print $2}' | head -n1)
    if [ -z "$CONN_MAC" ]; then 
        echo " Connected Device: [ 🔵 Not Connected ]"
    else 
        DEVICE=$(timeout 2 bluetoothctl info "$CONN_MAC" 2>/dev/null | grep "Name:" | cut -d' ' -f2- | cut -c 1-8)
        echo " Connected Device: [ 🟢 $DEVICE ]"
    fi
fi

echo "======================================="
read -p "Press Enter to open blueman-manager..."

echo -e "\n[*] Launching blueman-manager..."
echo "---------------------------------------"

blueman-manager

echo "---------------------------------------"
read -n 1 -s -r -p "Press any key to close this window..."
echo ""
exit 0
