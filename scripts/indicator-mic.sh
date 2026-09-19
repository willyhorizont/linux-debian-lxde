#!/bin/bash

MIC_VOL=$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '{print $5}' | head -n1 | tr -d '%')
MIC_PAD=$(printf "%3d" "$MIC_VOL")
MIC_MUTE=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
if [ "$MIC_MUTE" = "yes" ]; then
    echo "[mic=n $MIC_PAD%]"
else
    echo "[mic=y $MIC_PAD%]"
fi
