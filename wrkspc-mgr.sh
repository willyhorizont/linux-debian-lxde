#!/bin/bash

SCRIPT_NAME="wrkspc-mgr.sh"

if ! command -v xdotool >/dev/null 2>&1 || ! command -v wmctrl >/dev/null 2>&1 || ! command -v xprop >/dev/null 2>&1; then
    notify-send "[$SCRIPT_NAME]" "Error: missing dependencies 'xdotool wmctrl xprop'..."
    exit 1
fi

tot_wrkspc=$(xdotool get_num_desktops 2>/dev/null)
cur_wrkspc=$(xdotool get_desktop 2>/dev/null)

OPEN_WINS_DATA=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh")
WS_NMS=$(xprop -root _NET_DESKTOP_NAMES 2>/dev/null | awk -F'"' '{for(i=2; i<=NF; i+=2) print $i}')
OPEN_WINS_WS=$(echo "$OPEN_WINS_DATA" | awk '{print $2}')

PROCESSED=0
MODE_SELECTED=false
MOV_WIN_MODE=false
MOV_WS_MODE=false
TRGT_WIN_ID=""
WIN_DATA=""
WIN_NM=""
WIN_META=""
FULL_NM=""
BYNAME_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --byname)
            BYNAME_MODE=true
            shift
            ;;
        --goto)
            MODE_SELECTED=true
            PROCESSED=1
            shift
            ;;
        --mov)
            MODE_SELECTED=true
            MOV_WIN_MODE=true
            WIN_DATA=$("$HOME/willyhorizont.github.io/linux/rofi-windows-task-view-mac-mission-control.sh" --print --title 'Choose Window to Move')
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
            TRGT_WIN_ID_HEX=$(printf "0x%08x" "$TRGT_WIN_ID" 2>/dev/null)
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
            if [ "$BYNAME_MODE" = true ]; then
                max_ws=$(echo "$WS_NMS" | awk '{
                    if (match($0, /[0-9]+/)) {
                        print substr($0, RSTART, RLENGTH);
                    }
                }' | sort -rn | head -n 1)
                if [ -z "$max_ws" ]; then max_ws=0; fi
                TRGT_WRKSPC=$(( max_ws + 1 ))
            else
                max_active_win_ws=-1
                if [ -n "$OPEN_WINS_WS" ]; then
                    max_active_win_ws=$(echo "$OPEN_WINS_WS" | sort -nu | tail -n 1)
                fi
                if [ "$cur_wrkspc" -gt "$max_active_win_ws" ]; then
                    max_valid_ws=$cur_wrkspc
                else
                    max_valid_ws=$max_active_win_ws
                fi
                if [ "$max_valid_ws" -lt 0 ]; then
                    max_valid_ws=0
                fi
                TRGT_WRKSPC=$(( max_valid_ws + 1 ))
            fi
            PROCESSED=1
            shift
            ;;
        --next|--prev)
            if [ "$BYNAME_MODE" = true ]; then
                mapfile -t valid_workspaces < <(echo "$WS_NMS")
                cur_idx=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')
                cur_ws_name=${valid_workspaces[$cur_idx]}
                tot_valid=${#valid_workspaces[@]}
                cur_pos=0
                for i in "${!valid_workspaces[@]}"; do
                    if [ "${valid_workspaces[$i]}" = "$cur_ws_name" ]; then
                        cur_pos=$i
                        break
                    fi
                done
                if [ "$1" = "--next" ]; then
                    trgt_pos=$(( (cur_pos + 1) % tot_valid ))
                else
                    trgt_pos=$(( (cur_pos - 1 + tot_valid) % tot_valid ))
                fi
                for i in "${!valid_workspaces[@]}"; do
                    if [ "${valid_workspaces[$i]}" = "${valid_workspaces[$trgt_pos]}" ]; then
                        TRGT_WRKSPC=$i
                        break
                    fi
                done
            else
                valid_workspaces=()
                for ((i=0; i<tot_wrkspc; i++)); do
                    win_count=0
                    if [ -n "$OPEN_WINS_WS" ]; then
                        win_count=$(echo "$OPEN_WINS_WS" | grep -c -w "$i")
                    fi
                    if [ "$win_count" -gt 0 ] || [ "$i" -eq "$cur_wrkspc" ]; then
                        valid_workspaces+=("$i")
                    fi
                done
                tot_valid=${#valid_workspaces[@]}
                cur_pos=0
                for i in "${!valid_workspaces[@]}"; do
                    if [ "${valid_workspaces[$i]}" -eq "$cur_wrkspc" ] 2>/dev/null; then
                        cur_pos=$i
                        break
                    fi
                done
                if [ "$1" = "--next" ]; then
                    trgt_pos=$(( (cur_pos + 1) % tot_valid ))
                else
                    trgt_pos=$(( (cur_pos - 1 + tot_valid) % tot_valid ))
                fi
                TRGT_WRKSPC=${valid_workspaces[$trgt_pos]}
            fi
            PROCESSED=1
            shift
            ;;
        --number)
            if ! echo "$2" | grep -qE '^[0-9]+$'; then
                notify-send "[$SCRIPT_NAME]" "Error: invalid arguments!"
                exit 1
            fi
            if [ "$BYNAME_MODE" = true ] && [ -n "$2" ]; then
                WS_NAME_BY_IDX=$(echo "$WS_NMS" | awk -v idx="$2" 'NR == idx {print $0}')
                if [ -n "$WS_NAME_BY_IDX" ]; then
                    mapfile -t all_ws_names < <(echo "$WS_NMS")
                    for i in "${!all_ws_names[@]}"; do
                        if [ "${all_ws_names[$i]}" = "$WS_NAME_BY_IDX" ]; then
                            TRGT_WRKSPC=$i
                            break
                        fi
                    done
                fi
                if [ -z "$TRGT_WRKSPC" ]; then TRGT_WRKSPC=$(( $2 - 1 )); fi
            else
                TRGT_WRKSPC=$(( $2 - 1 ))
            fi
            PROCESSED=1
            shift 2
            ;;
        *)
            echo "Usage: $0 [--byname] [--goto] [--mov] [--mov-cur-win] [--mov-cur-ws] [--plus] [--prev] [--next] [--number workspace_number]"
            exit 1
            ;;
    esac
done

if [ -z "$TRGT_WRKSPC" ]; then
    PROCESSED=0
fi

if [ -z "$WIN_META" ] && [ -z "$FULL_NM" ]; then
    TRGT_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
    TRGT_WIN_ID_HEX=$(printf "0x%08x" "$TRGT_WIN_ID" 2>/dev/null)
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

if [ "$BYNAME_MODE" = true ]; then
    mapfile -t all_ws_names < <(echo "$WS_NMS")
    CUR_WS_NM="${all_ws_names[$cur_wrkspc]}"
    if [ -z "$CUR_WS_NM" ]; then
        CUR_WS_NM=$((cur_wrkspc + 1))
    fi
else
    CUR_WS_NM=$((cur_wrkspc + 1))
fi
WS_NM="[${CUR_WS_NM}]"

CUR_WS_WINS=$(echo "$OPEN_WINS_DATA" | awk -v ws="$cur_wrkspc" '$2 == ws {print $1}')

MAIN_MENU_OPTIONS=(
    "Go to Workspace"
)

if [ -n "$OPEN_WINS_DATA" ]; then
    if [ -n "$WIN_DATA" ]; then
        MAIN_MENU_OPTIONS+=(
            "Move Window to Workspace"
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
    EXTRA_ARGS=()
    [ "$BYNAME_MODE" = true ] && EXTRA_ARGS+=("--byname")
    case "$MAIN_MENU_CHOICE" in
        "Go to Workspace")
            exec "$0" "${EXTRA_ARGS[@]}" --goto
            ;;
        "Move Window to Workspace")
            exec "$0" "${EXTRA_ARGS[@]}" --mov
            ;;
        "Move $WIN_NM to Workspace")
            exec "$0" "${EXTRA_ARGS[@]}" --mov-cur-win
            ;;
        "Move Windows in Workspace $WS_NM to Other Workspace")
            exec "$0" "${EXTRA_ARGS[@]}" --mov-cur-ws
            ;;
        "New Workspace")
            exec "$0" "${EXTRA_ARGS[@]}" --plus
            ;;
        "Next Workspace")
            exec "$0" "${EXTRA_ARGS[@]}" --next
            ;;
        "Previous Workspace")
            exec "$0" "${EXTRA_ARGS[@]}" --prev
            ;;
        *)
            exit 0
            ;;
    esac
fi

if [ $PROCESSED -eq 0 ]; then
    ROFI_LIST=""
    if [ "$BYNAME_MODE" = true ]; then
        ROFI_LIST=$(echo "$WS_NMS" | tr '\n' '\\' | sed 's/\\/\\n/g' | sed 's/\\n$//')
    else
        for ((i=0; i<tot_wrkspc; i++)); do
            win_count=0
            if [ -n "$OPEN_WINS_WS" ]; then
                win_count=$(echo "$OPEN_WINS_WS" | grep -c -w "$i")
            fi
            if [ "$win_count" -gt 0 ]; then
                display_num=$((i + 1))
                if [ -z "$ROFI_LIST" ]; then
                    ROFI_LIST="$display_num"
                else
                    ROFI_LIST="${ROFI_LIST}\n${display_num}"
                fi
            fi
        done
    fi
    if [ "$MOV_WIN_MODE" = true ]; then
        PROMPT_MSG="Move $WIN_NM to Workspace"
        ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG" -theme-str 'window { width: 90%; }')
    elif [ "$MOV_WS_MODE" = true ]; then
        PROMPT_MSG="Move Windows in Workspace $WS_NM to Other Workspace"
        ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG" -theme-str 'window { width: 90%; }')
    else
        PROMPT_MSG="Go to Workspace"
        ROFI_INPUT=$(echo -e "$ROFI_LIST" | rofi -dmenu -p "$PROMPT_MSG")
    fi
    if [ -z "$ROFI_INPUT" ]; then
        exit 0
    fi
    if [ "$BYNAME_MODE" = true ]; then
        mapfile -t all_ws_names < <(echo "$WS_NMS")
        for i in "${!all_ws_names[@]}"; do
            if [ "${all_ws_names[$i]}" = "$ROFI_INPUT" ]; then
                TRGT_WRKSPC=$i
                break
            fi
        done
        if [ -z "$TRGT_WRKSPC" ]; then TRGT_WRKSPC="$ROFI_INPUT"; fi
    else
        if echo "$ROFI_INPUT" | grep -qE '^[0-9]+$'; then
            TRGT_WRKSPC=$(( ROFI_INPUT - 1 ))
        else
            TRGT_WRKSPC="$ROFI_INPUT"
        fi
    fi
fi

if [ -z "$TRGT_WRKSPC" ]; then
    exit 0
fi

if echo "$TRGT_WRKSPC" | grep -qE '^[0-9]+$'; then
    if [ "$TRGT_WRKSPC" -ge "$tot_wrkspc" ]; then
        tot_wrkspc_nu=$((TRGT_WRKSPC + 1))
        xdotool set_num_desktops $tot_wrkspc_nu
    fi
    if [ "$MOV_WIN_MODE" = true ]; then
        xdotool set_desktop_for_window "$TRGT_WIN_ID" "$TRGT_WRKSPC"
    elif [ "$MOV_WS_MODE" = true ]; then
        while read -r WID; do
            [ -n "$WID" ] && xdotool set_desktop_for_window "$WID" "$TRGT_WRKSPC"
        done <<< "$CUR_WS_WINS"
    fi
    xdotool set_desktop "$TRGT_WRKSPC"
else
    notify-send "[$SCRIPT_NAME]" "Error: invalid input!"
fi
