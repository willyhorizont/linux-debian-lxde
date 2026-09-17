#!/bin/bash

CURRENT=$(powerprofilesctl get 2>/dev/null)

echo "======================================="
echo "          POWER PROFILES TUI           "
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
        if powerprofilesctl set balanced 2>/dev/null; then
            echo -e "\n[+] Successfully set to BALANCED mode."
        else
            echo -e "\n[!] Failed! BALANCED mode is not supported on this hardware."
        fi
        ;;
    2)
        if powerprofilesctl set power-saver 2>/dev/null; then
            echo -e "\n[+] Successfully set to POWER-SAVER mode."
        else
            echo -e "\n[!] Failed! POWER-SAVER mode is not supported on this hardware."
        fi
        ;;
    3)
        if powerprofilesctl set performance 2>/dev/null; then
            echo -e "\n[+] Successfully set to PERFORMANCE mode."
        else
            echo -e "\n[!] Failed! PERFORMANCE mode is not supported on this hardware."
        fi
        ;;
    *)
        echo -e "\n[!] Invalid choice! No changes made."
        ;;
esac

echo "---------------------------------------"
read -n 1 -s -r -p "Press any key to close this window..."
echo ""
exit 0
