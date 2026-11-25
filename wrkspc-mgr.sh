#!/bin/bash

SCRIPT_NAME="wrkspc-mgr.sh"
case "$DESKTOP_SESSION" in
    LXDE|openbox)
        if ! command -v wmctrl &> /dev/null || ! command -v xprop &> /dev/null || ! command -v xdotool &> /dev/null; then
            notify-send "[$SCRIPT_NAME]" "Error: missing dependencies 'wmctrl xprop xdotool'"
            exit 1
        fi
        ;;
    i3)
        if ! command -v i3-msg &> /dev/null || ! command -v jq &> /dev/null; then
            notify-send "[$SCRIPT_NAME]" "Error: missing dependencies 'i3-msg jq'"
            exit 1
        fi
        ;;
    *)
        notify-send "[$SCRIPT_NAME]" "Unsupported DESKTOP_SESSION: '$DESKTOP_SESSION'"
        exit 1
        ;;
esac

switch_workspace() {
    local trgt_ws_nm="$1"
    if ! echo "$trgt_ws_nm" | grep -qE '^[0-9]+$'; then
        notify-send "[$SCRIPT_NAME]" "Error: invalid input!"
        exit 1
    fi
    case "$DESKTOP_SESSION" in
        LXDE|openbox)
            local ws_nms_len
            local trgt_ws_i
            trgt_ws_i=$((trgt_ws_nm - 1))
            ws_nms_len=$(xdotool get_num_desktops 2>/dev/null)
            if [ "$trgt_ws_i" -ge "${ws_nms_len:-1}" ]; then
                xdotool set_num_desktops $((trgt_ws_i + 1))
            fi
            if [ "$MOV_WIN_MODE" = true ]; then
                xdotool set_desktop_for_window "$TRGT_WIN_ID" "$trgt_ws_i"
            elif [ "$MOV_WS_MODE" = true ]; then
                while read -r WID; do
                    [ -n "$WID" ] && xdotool set_desktop_for_window "$WID" "$trgt_ws_i"
                done <<< "$CUR_WS_WIDS"
            fi
            xdotool set_desktop "$trgt_ws_i"
            ;;
        i3)
            if [ "$MOV_WIN_MODE" = true ]; then
                i3-msg "[id=\"$TRGT_WIN_ID\"] move container to workspace number $trgt_ws_nm" >/dev/null
            elif [ "$MOV_WS_MODE" = true ]; then
                i3-msg "[workspace=\"$CUR_WS_NM\"] move container to workspace number $trgt_ws_nm" >/dev/null
            fi
            i3-msg workspace "$trgt_ws_nm" >/dev/null
            ;;
    esac
}

IS_I3_MODE=false
MODE_SELECTED=false
MOV_WIN_MODE=false
MOV_WS_MODE=false
TRGT_WIN_ID=""
WIN_DATA=""
WIN_NM=""
WIN_META=""
FULL_NM=""
CUR_WS_NM=""
CUR_WS_WIDS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --i3-mode)
            IS_I3_MODE=true
            shift
            ;;
        --goto)
            MODE_SELECTED=true
            shift
            ;;
        --mov)
            MODE_SELECTED=true
            MOV_WIN_MODE=true
            WIN_DATA=$("$HOME/willyhorizont.github.io/linux-debian-lxde/rofi-windows-task-view-mac-mission-control.sh" --print --title "[$SCRIPT_NAME] Choose Window to Move")
            if [ "$WIN_DATA" = "Back" ]; then
                exec "$0"
            fi
            TRGT_WIN_ID=$(echo "$WIN_DATA" | awk '{print $1}')
            if [ -z "$TRGT_WIN_ID" ]; then
                exit 0
            fi
            WIN_META=$(echo "$WIN_DATA" | awk '{print $1 " " $3}')
            FULL_NM=$(echo "$WIN_DATA" | awk '{$1=$2=$3=""; sub(/^[ \t]+/, ""); print}')
            shift
            ;;
        --mov-cur-win)
            MODE_SELECTED=true
            MOV_WIN_MODE=true
            TRGT_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
            if [ -z "$TRGT_WIN_ID" ]; then
                notify-send "[$SCRIPT_NAME]" "Error: active window not found!"
                exit 1
            fi
            OPEN_WINS_DATA=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh")
            TRGT_WIN_ID_HEX=$(printf "0x%08llx" "$TRGT_WIN_ID" 2>/dev/null || printf "0x%08x" "$TRGT_WIN_ID" 2>/dev/null)
            WIN_DATA=$(echo "$OPEN_WINS_DATA" | awk -v wid="$TRGT_WIN_ID" -v widhex="$TRGT_WIN_ID_HEX" 'tolower($1) == tolower(wid) || tolower($1) == tolower(widhex) {print $0}')
            WIN_META=$(echo "$WIN_DATA" | awk '{print $1 " " $7}')
            FULL_NM=$(echo "$WIN_DATA" | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; sub(/^[ \t]+/, ""); print}')
            shift
            ;;
        --mov-cur-ws)
            MODE_SELECTED=true
            MOV_WS_MODE=true
            shift
            ;;
        --plus)
            case "$DESKTOP_SESSION" in
                LXDE|openbox)
                    if [ "$IS_I3_MODE" = true ]; then
                        CUR_WS_NM=$(( $(xdotool get_desktop 2>/dev/null) + 1 ))
                        LS_WS_NM=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh" | awk '{print $2 + 1}')
                        MAX_OPEN_WINS_WS_NM=0
                        if [ -n "$LS_WS_NM" ]; then
                            MAX_OPEN_WINS_WS_NM=$(echo "$LS_WS_NM" | sort -nu | tail -n 1)
                        fi
                        if [ "$CUR_WS_NM" -gt "$MAX_OPEN_WINS_WS_NM" ]; then
                            MAX_NON_EMPTY_OR_CUR_WS_NM=$CUR_WS_NM
                        else
                            MAX_NON_EMPTY_OR_CUR_WS_NM=$MAX_OPEN_WINS_WS_NM
                        fi
                        if [ "$MAX_NON_EMPTY_OR_CUR_WS_NM" -lt 1 ]; then
                            MAX_NON_EMPTY_OR_CUR_WS_NM=1
                        fi
                        TRGT_WS_NM=$((MAX_NON_EMPTY_OR_CUR_WS_NM + 1))
                    else
                        WS_NMS_LEN=$(xdotool get_num_desktops 2>/dev/null)
                        TRGT_WS_NM="$WS_NMS_LEN"
                    fi
                    ;;
                i3)
                    TRGT_WS_NM=$(i3-msg -t get_workspaces | jq '[.[].num] | max + 1')
                    ;;
            esac
            switch_workspace "$TRGT_WS_NM"
            exit 0
            ;;
        --prev|--next)
            case "$DESKTOP_SESSION" in
                LXDE|openbox)
                    if [ "$IS_I3_MODE" = true ]; then
                        WS_NMS_LEN=$(xdotool get_num_desktops 2>/dev/null)
                        CUR_WS_I=$(xdotool get_desktop 2>/dev/null)
                        LS_WS_I=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh" | awk '{print $2}')
                        NON_EMPTY_AND_CUR_WS_I_LS=()
                        for ((I=0; I<WS_NMS_LEN; I++)); do
                            OPEN_WINS_COUNT=0
                            if [ -n "$LS_WS_I" ]; then
                                OPEN_WINS_COUNT=$(echo "$LS_WS_I" | grep -c -w "$I")
                            fi
                            if [ "$OPEN_WINS_COUNT" -gt 0 ] || [ "$I" -eq "$CUR_WS_I" ]; then
                                NON_EMPTY_AND_CUR_WS_I_LS+=("$I")
                            fi
                        done
                        NON_EMPTY_AND_CUR_WS_I_LS_LEN=${#NON_EMPTY_AND_CUR_WS_I_LS[@]}
                        CUR_WS_I_NU=0
                        for I in "${!NON_EMPTY_AND_CUR_WS_I_LS[@]}"; do
                            if [ "${NON_EMPTY_AND_CUR_WS_I_LS[$I]}" -eq "$CUR_WS_I" ] 2>/dev/null; then
                                CUR_WS_I_NU=$I
                                break
                            fi
                        done
                        if [ "$1" = "--next" ]; then
                            NON_EMPTY_AND_CUR_WS_I_LS_I=$(( (CUR_WS_I_NU + 1) % NON_EMPTY_AND_CUR_WS_I_LS_LEN ))
                        else
                            NON_EMPTY_AND_CUR_WS_I_LS_I=$(( (CUR_WS_I_NU - 1 + NON_EMPTY_AND_CUR_WS_I_LS_LEN) % NON_EMPTY_AND_CUR_WS_I_LS_LEN ))
                        fi
                        TRGT_WS_NM=$((${NON_EMPTY_AND_CUR_WS_I_LS[$NON_EMPTY_AND_CUR_WS_I_LS_I]} + 1))
                        switch_workspace "$TRGT_WS_NM"
                    else
                        WS_NMS_LEN=$(xdotool get_num_desktops 2>/dev/null)
                        CUR_WS_I=$(xdotool get_desktop 2>/dev/null)
                        if [ "$1" = "--next" ]; then
                            TRGT_WS_I=$(( (CUR_WS_I + 1) % WS_NMS_LEN ))
                        else
                            TRGT_WS_I=$(( (CUR_WS_I - 1 + WS_NMS_LEN) % WS_NMS_LEN ))
                        fi
                        TRGT_WS_NM=$((TRGT_WS_I + 1))
                        switch_workspace "$TRGT_WS_NM"
                    fi
                    ;;
                i3)
                    if [ "$1" = "--next" ]; then
                        i3-msg workspace next >/dev/null
                    else
                        i3-msg workspace prev >/dev/null
                    fi
                    ;;
            esac
            exit 0
            ;;
        --number)
            switch_workspace "$2"
            exit 0
            ;;
        *)
            echo "Usage: $0 [--goto] [--mov] [--mov-cur-win] [--mov-cur-ws] [--plus] [--prev] [--next] [--number workspace_number]"
            exit 1
            ;;
    esac
done

OPEN_WINS_DATA=${OPEN_WINS_DATA:-$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh")}
WS_NMS=$(xprop -root _NET_DESKTOP_NAMES 2>/dev/null | awk -F'"' '{for(i=2; i<=NF; i+=2) {gsub(/[^0-9]/, "", $i); print ($i != "" ? $i : "404")}}')
CUR_WS_I=$(xdotool get_desktop 2>/dev/null)

if [ -z "$WIN_META" ] && [ -z "$FULL_NM" ]; then
    TRGT_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
    TRGT_WIN_ID_HEX=$(printf "0x%08llx" "$TRGT_WIN_ID" 2>/dev/null || printf "0x%08x" "$TRGT_WIN_ID" 2>/dev/null)
    WIN_DATA=$(echo "$OPEN_WINS_DATA" | awk -v wid="$TRGT_WIN_ID" -v widhex="$TRGT_WIN_ID_HEX" 'tolower($1) == tolower(wid) || tolower($1) == tolower(widhex) {print $0}')
    WIN_META=$(echo "$WIN_DATA" | awk '{print $1 " " $7}')
    FULL_NM=$(echo "$WIN_DATA" | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; sub(/^[ \t]+/, ""); print}')
fi

if [ -z "$WIN_NM" ]; then
    if [ ${#FULL_NM} -gt 43 ]; then
        SHORT_NM="${FULL_NM:0:20}...${FULL_NM: -20}"
    else
        SHORT_NM="$FULL_NM"
    fi
    WIN_NM="$WIN_META $SHORT_NM"
    WIN_NM="[${WIN_NM}]"
fi

case "$DESKTOP_SESSION" in
    LXDE|openbox)
        CUR_WS_NM=$(echo "$WS_NMS" | awk -v ws_i="$CUR_WS_I" 'NR == ws_i + 1 {print $0}')
        ;;
    i3)
        CUR_WS_NM=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).num')
        ;;
esac
WS_NM="[${CUR_WS_NM}]"

CUR_WS_WIDS=$(echo "$OPEN_WINS_DATA" | awk -v ws="$CUR_WS_I" '$2 == ws {print $1}')

MAIN_MENU_OPTIONS=(
    "Go to Workspace"
)

if [ -n "$OPEN_WINS_DATA" ]; then
    MAIN_MENU_OPTIONS+=(
        "Move Window to Workspace"
    )
    if [ -n "$WIN_DATA" ]; then
        MAIN_MENU_OPTIONS+=(
            "Move $WIN_NM to Workspace"
        )
    fi
    if [ -n "$CUR_WS_WIDS" ]; then
        MAIN_MENU_OPTIONS+=(
            "Move Windows in Workspace $WS_NM to Other Workspace"
        )
    fi
fi

MAIN_MENU_OPTIONS+=(
    "New Workspace"
    "Next Workspace"
    "Previous Workspace"
)

if [ "$MODE_SELECTED" = false ]; then
    MAIN_MENU_CHOICE=$(printf "%s\n" "${MAIN_MENU_OPTIONS[@]}" | rofi -dmenu -p "$SCRIPT_NAME" -theme-str 'window { width: 90%; }')
    case "$MAIN_MENU_CHOICE" in
        "Go to Workspace")
            exec "$0" --goto
            ;;
        "Move Window to Workspace")
            exec "$0" --mov
            ;;
        "Move $WIN_NM to Workspace")
            exec "$0" --mov-cur-win
            ;;
        "Move Windows in Workspace $WS_NM to Other Workspace")
            exec "$0" --mov-cur-ws
            ;;
        "New Workspace")
            exec "$0" --plus
            ;;
        "Next Workspace")
            exec "$0" --next
            ;;
        "Previous Workspace")
            exec "$0" --prev
            ;;
        *)
            exit 0
            ;;
    esac
fi

ROFI_LIST="Back"
[ -n "$WS_NMS" ] && ROFI_LIST="${ROFI_LIST}\n${WS_NMS}"
if [ "$MOV_WIN_MODE" = true ]; then
    PROMPT_MSG="[$SCRIPT_NAME] Move $WIN_NM to Workspace"
    ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG" -theme-str 'window { width: 90%; }')
elif [ "$MOV_WS_MODE" = true ]; then
    PROMPT_MSG="[$SCRIPT_NAME] Move Windows in Workspace $WS_NM to Other Workspace"
    ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG" -theme-str 'window { width: 90%; }')
else
    PROMPT_MSG="[$SCRIPT_NAME] Go to Workspace"
    ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG")
fi

if [ -z "$ROFI_INPUT" ]; then
    exit 0
elif [ "$ROFI_INPUT" = "Back" ]; then
    exec "$0"
fi

TRGT_WS_NM="$ROFI_INPUT"

if [ -z "$TRGT_WS_NM" ]; then
    exit 0
fi

switch_workspace "$TRGT_WS_NM"
