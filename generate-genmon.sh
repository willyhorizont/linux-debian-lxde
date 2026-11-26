#!/bin/bash

# bottom-panel

CMDS=(
    "echo \"<txt>| _ </txt><txtclick>xdotool key ctrl+super+d</txtclick><tool>Toggle Show Desktop</tool>\""
    "echo \"<txt>| 🔔 </txt><txtclick>dunstctl history-pop</txtclick><tool>Notification History</tool>\""
    "\$HOME/willyhorizont.github.io/linux/powr-indctr.sh --pref '| ' --sep ' | '"
    "\$HOME/willyhorizont.github.io/linux/vol.sh --indicator --pref '| '"
    "\$HOME/willyhorizont.github.io/linux/mic.sh --indicator --pref '| '"
    "\$HOME/willyhorizont.github.io/linux/cam.sh --indicator --pref '| '"
    "\$HOME/willyhorizont.github.io/linux/net.sh --indicator --pref '| '"
    "\$HOME/willyhorizont.github.io/linux/bt.sh --indicator --pref '| '"
    "\$HOME/willyhorizont.github.io/linux/tux-indctr.sh"
)

START_ID=7
TOTAL=${#CMDS[@]}

for ((i = TOTAL - 1; i >= 0; i--)); do
    NUM=$((START_ID + i))
    GENMON_ID="genmon-${NUM}"
    CMD="${CMDS[$i]}"
    if [[ "$CMD" == echo* ]]; then
        FINAL_CMD="sh -c '$CMD'"
    else
        FINAL_CMD="sh -c \"$CMD --mode xfce4-panel --genmon-id $GENMON_ID\""
    fi
    cat << EOF > ".config/xfce4/panel/${GENMON_ID}.rc"
Command=${FINAL_CMD}
UseLabel=0
Text=(genmon)
UpdatePeriod=86400000
Font=JetBrains Mono Bold 8
EOF
done

for ((i = TOTAL - 1; i >= 0; i--)); do
    NUM=$((START_ID + i))
    echo "                <value type=\"int\" value=\"${NUM}\" />"
done

echo ""

for ((i = TOTAL - 1; i >= 0; i--)); do
    NUM=$((START_ID + i))
    echo "        <property name=\"plugin-${NUM}\" type=\"string\" value=\"genmon\" />"
done

# top-bar

# E # 16 # SPRM
# E # 17 # uptime
# F # 101 # sep
# F # 102 # sep
# E # 18 # free-text
# F # 103 # sep
# E # 19 # empty-text
# F # 104 # sep
# E # 20 # free-text
# F # 105 # sep
# F # 106 # sep
# E # 21 # WhatIsThis
# E # 22 # WhoAmI
# E # 23 # SuckMyClock
