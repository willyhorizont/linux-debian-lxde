#!/bin/bash

if [ ! -d /sys/class/power_supply ] || [ -z "$(ls /sys/class/power_supply/ | grep -E '^BAT|^battery')" ]; then
    echo "AC=y ; batt=n     "
    exit 0
else
    ACPI_OUT=$(acpi -b | head -n1)
    CAP=$(echo "$ACPI_OUT" | awk -F', ' '{print $2}' | tr -d '% ')
    CAP_PAD=$(printf "%3d" "$CAP")
    if echo "$ACPI_OUT" | grep -F ", Charging," > /dev/null || echo "$ACPI_OUT" | grep -q "[: ]Charging,"; then
        if [ "$CAP" -ge 40 ]; then
            echo "AC=y ; batt=y $CAP_PAD%"
        else
            echo "AC=y ; batt=y $CAP_PAD%"
        fi
    else
        if [ "$CAP" -ge 40 ]; then
            echo "AC=n ; batt=y $CAP_PAD%"
        else
            echo "AC=n ; batt=y $CAP_PAD%"
        fi
    fi
fi
