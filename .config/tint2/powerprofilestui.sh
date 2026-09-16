#!/bin/bash

CURRENT=$(powerprofilesctl get 2>/dev/null)

echo "======================================="
echo "      POWER PROFILES CONSOLE TUI       "
echo "======================================="
echo " Active Profile: [ ${CURRENT:-unknown} ]"
echo "---------------------------------------"
echo " 1) Balanced (Default)"
echo " 2) Power Saver"
echo " 3) Performance"
echo "======================================="
read -p " Select mode [1-3] (Default: 1): " CHOICE

if [ -z "$CHOICE" ]; then
    CHOICE=1
fi

case "$CHOICE" in
    1)
        powerprofilesctl set balanced
        echo -e "\n[+] Successfully set to BALANCED mode."
        ;;
    2)
        powerprofilesctl set power-saver
        echo -e "\n[+] Successfully set to POWER-SAVER mode."
        ;;
    3)
        powerprofilesctl set performance
        echo -e "\n[+] Successfully set to PERFORMANCE mode."
        ;;
    *)
        echo -e "\n[!] Invalid choice! No changes made."
        ;;
esac

echo "---------------------------------------"
read -n 1 -s -r -p "Press any key to close this window..."
echo ""
