#!/bin/bash

SCRIPT_NAME="wrkspc-mgr.sh"

if ! command -v xdotool >/dev/null 2>&1 || ! command -v wmctrl >/dev/null 2>&1 || ! command -v xprop >/dev/null 2>&1; then
    notify-send "[$SCRIPT_NAME]" "Error: missing dependencies 'xdotool wmctrl xprop'..."
    exit 1
fi

OPEN_WINS_DATA=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh")

PROCESSED=0
MODE_SELECTED=false
MOV_WIN_MODE=false
MOV_WS_MODE=false
TRGT_WIN_ID=""
WIN_DATA=""
WIN_NM=""
WIN_META=""
FULL_NM=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --goto)
            MODE_SELECTED=true
            PROCESSED=1
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
            PROCESSED=1
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
            TRGT_WIN_ID_HEX=$(printf "0x%08llx" "$TRGT_WIN_ID" 2>/dev/null || printf "0x%08x" "$TRGT_WIN_ID" 2>/dev/null)
            WIN_DATA=$(echo "$OPEN_WINS_DATA" | awk -v wid="$TRGT_WIN_ID" -v widhex="$TRGT_WIN_ID_HEX" 'tolower($1) == tolower(wid) || tolower($1) == tolower(widhex) {print $0}')
            WIN_META=$(echo "$WIN_DATA" | awk '{print $1 " " $7}')
            FULL_NM=$(echo "$WIN_DATA" | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; sub(/^[ \t]+/, ""); print}')
            PROCESSED=1
            shift
            ;;
        --mov-cur-ws)
            MODE_SELECTED=true
            MOV_WS_MODE=true
            PROCESSED=1
            shift
            ;;
        --plus)
            TRGT_WRKSPC=$(i3-msg -t get_workspaces | jq '[.[].num] | max + 1')
            PROCESSED=1
            shift
            ;;
        --prev)
            i3-msg workspace prev
            exit 0
            ;;
        --next)
            i3-msg workspace next
            exit 0
            ;;
        --number)
            TRGT_WRKSPC=$2
            PROCESSED=1
            shift 2
            ;;
        *)
            echo "Usage: $0 [--goto] [--mov] [--mov-cur-win] [--mov-cur-ws] [--plus] [--prev] [--next] [--number workspace_number]"
            exit 1
            ;;
    esac
done

if [ -z "$TRGT_WRKSPC" ]; then
    PROCESSED=0
fi

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

CUR_WS_NM=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).num')
WS_NM="[${CUR_WS_NM}]"

cur_wrkspc=$(xdotool get_desktop 2>/dev/null)
CUR_WS_WINS=$(echo "$OPEN_WINS_DATA" | awk -v ws="$cur_wrkspc" '$2 == ws {print $1}')

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
    if [ -n "$CUR_WS_WINS" ]; then
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

if [ $PROCESSED -eq 0 ] && [ "$MODE_SELECTED" = false ]; then
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

if [ $PROCESSED -eq 0 ]; then
    ROFI_LIST="Back"
    WS_LIST=$(xprop -root _NET_DESKTOP_NAMES 2>/dev/null | awk -F'"' '{for(i=2; i<=NF; i+=2) print $i}' | tr '\n' '\\' | sed 's/\\/\\n/g' | sed 's/\\n$//')
    [ -n "$WS_LIST" ] && ROFI_LIST="${ROFI_LIST}\n${WS_LIST}"
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
    TRGT_WRKSPC="$ROFI_INPUT"
fi

if [ -z "$TRGT_WRKSPC" ]; then
    exit 0
fi

if echo "$TRGT_WRKSPC" | grep -qE '^[0-9]+$'; then
    if [ "$MOV_WIN_MODE" = true ]; then
        i3-msg "[id=\"$TRGT_WIN_ID\"] move container to workspace number $TRGT_WRKSPC"
    elif [ "$MOV_WS_MODE" = true ]; then
        i3-msg "[workspace=\"$CUR_WS_NM\"] move container to workspace number $TRGT_WRKSPC"
    fi
    i3-msg workspace "$TRGT_WRKSPC"
else
    notify-send "[$SCRIPT_NAME]" "Error: invalid input!"
fi
