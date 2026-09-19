#!/bin/bash

VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1 | tr -d '%')
VOL_PAD=$(printf "%3d" "$VOL")
SINK_MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
if [ "$SINK_MUTE" = "yes" ]; then
    echo "[vol=n $VOL_PAD%]"
else
    echo "[vol=y $VOL_PAD%]" 
fi
