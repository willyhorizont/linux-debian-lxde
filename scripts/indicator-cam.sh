#!/bin/bash

if [ -f /sys/class/video4linux/video0/device/power/runtime_status ]; then
    STATUS=$(cat /sys/class/video4linux/video0/device/power/runtime_status)
    if [ "$STATUS" = "active" ]; then
        echo "[cam=y]"
    else
        echo "[cam=n]"
    fi
else
    echo "[cam=n]"
fi
