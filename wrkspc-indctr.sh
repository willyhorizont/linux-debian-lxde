#!/bin/bash

SCRIPT_NAME="wrkspc-indctr.sh"

case "$DESKTOP_SESSION" in
    LXDE|openbox)
        if ! command -v wmctrl >/dev/null 2>&1 || ! command -v xprop >/dev/null 2>&1 || ! command -v xdotool >/dev/null 2>&1; then
            echo "Error: missing dependencies 'wmctrl xprop xdotool'"
            exit 1
        fi
        ;;
    i3)
        if ! command -v i3-msg >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
            echo "Error: missing dependencies 'i3-msg jq'"
            exit 1
        fi
        ;;
    *)
        echo "[$SCRIPT_NAME]" "Unsupported DESKTOP_SESSION: '$DESKTOP_SESSION'"
        exit 1
        ;;
esac

IS_MGR_MODE=false
IS_NMBRZ_MODE=false
IS_DSKTP_MODE=false
SHOW_WINS=false
REVERSE_ORDER=false
USE_PANGO=false
MAX_WIDTH=0
MOCK_DATA=""
PREF=""
SUFF=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --mgr-mode)
            IS_MGR_MODE=true
            shift
            ;;
        --nmbrz-mode)
            IS_NMBRZ_MODE=true
            shift
            ;;
        --desktop-mode)
            IS_DSKTP_MODE=true
            shift
            ;;
        --shw-wins)
            SHOW_WINS=true
            shift
            ;;
        --rev)
            REVERSE_ORDER=true
            shift
            ;;
        --pango)
            USE_PANGO=true
            shift
            ;;
        --max-width)
            MAX_WIDTH="$2"
            shift 2
            ;;
        --data)
            MOCK_DATA="$2"
            shift 2
            ;;
        --pref)
            PREF="$2"
            shift 2
            ;;
        --suff)
            SUFF="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

fetch_workspaces() {
    WS_NAMES=()
    WS_FOCUSED=()
    CUR_IDX=0
    local idx=0
    if [ -n "$MOCK_DATA" ]; then
        IFS='|' read -ra items <<< "$MOCK_DATA"
        for item in "${items[@]}"; do
            if [ -z "$item" ]; then continue; fi
            if [[ "$item" == *"*" ]]; then
                WS_NAMES+=("${item%\*}")
                WS_FOCUSED+=("true")
                CUR_IDX=$idx
            else
                WS_NAMES+=("$item")
                WS_FOCUSED+=("false")
            fi
            idx=$((idx + 1))
        done
    else
        case "$DESKTOP_SESSION" in
            LXDE|openbox)
                local cur_ws_i
                local ls_ws
                local max_open_wins_ws_i
                local max_non_empty_or_cur_ws_i
                local ws_nms_len_nu
                cur_ws_i=$(xdotool get_desktop 2>/dev/null)
                ls_ws=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh" | awk '{print $2}')
                max_open_wins_ws_i=-1
                if [ -n "$ls_ws" ]; then
                    max_open_wins_ws_i=$(echo "$ls_ws" | sort -nu | tail -n 1)
                fi
                if [ "$cur_ws_i" -gt "$max_open_wins_ws_i" ]; then
                    max_non_empty_or_cur_ws_i=$cur_ws_i
                else
                    max_non_empty_or_cur_ws_i=$max_open_wins_ws_i
                fi
                if [ "$max_non_empty_or_cur_ws_i" -lt 0 ]; then
                    max_non_empty_or_cur_ws_i=0
                fi
                ws_nms_len_nu=$((max_non_empty_or_cur_ws_i + 1))
                local ws_nms_len
                ws_nms_len=$(xdotool get_num_desktops 2>/dev/null)
                if [ "$ws_nms_len" -ne "$ws_nms_len_nu" ]; then
                    xdotool set_num_desktops "$ws_nms_len_nu"
                    ws_nms_len="$ws_nms_len_nu"
                fi
                [ "$IS_MGR_MODE" = true ] && return 0
                local start_loop
                local end_loop
                local step
                if [ "$REVERSE_ORDER" = true ]; then
                    start_loop=$((ws_nms_len - 1))
                    end_loop=0
                    step=-1
                else
                    start_loop=0
                    end_loop=$((ws_nms_len - 1))
                    step=1
                fi
                local i
                local open_wins_count
                local ws_disp_nm
                local el
                for ((i = start_loop; step == 1 ? i <= end_loop : i >= end_loop; i += step)); do
                    if [ "$SHOW_WINS" = true ]; then
                        open_wins_count=$(echo "$ls_ws" | grep -c -w "$i")
                    else
                        if echo "$ls_ws" | grep -q -w "$i"; then
                            open_wins_count=1
                        else
                            open_wins_count=0
                        fi
                    fi
                    if [ "$open_wins_count" -eq 0 ] && [ "$i" -ne "$cur_ws_i" ]; then
                        continue
                    fi
                    local ws_nms
                    ws_nms=$(xprop -root _NET_DESKTOP_NAMES 2>/dev/null | awk -F'"' '{for(i=2; i<=NF; i+=2) {gsub(/[^0-9]/, "", $i); print ($i != "" ? $i : "404")}}')
                    ws_disp_nm=$(echo "$ws_nms" | awk -v ws_i="$i" 'NR == ws_i + 1 {print $0}')
                    if [ "$SHOW_WINS" = true ]; then
                        el="${open_wins_count}wins@ws${ws_disp_nm}"
                    else
                        el="${ws_disp_nm}"
                    fi
                    WS_NAMES+=("$el")
                    if [ "$i" -eq "$cur_ws_i" ]; then
                        WS_FOCUSED+=("true")
                        CUR_IDX=$idx
                    else
                        WS_FOCUSED+=("false")
                    fi
                    idx=$((idx + 1))
                done
                ;;
            i3)
                local ws_data
                ws_data=$(i3-msg -t get_workspaces 2>/dev/null)
                [ -z "$ws_data" ] && return 1
                local parsed_ws
                parsed_ws=$(echo "$ws_data" | jq -r '.[] | "\(.name) \(.focused)"')
                [ "$REVERSE_ORDER" = true ] && parsed_ws=$(echo "$parsed_ws" | tac)
                while read -r name focused; do
                    if [ -z "$name" ]; then continue; fi
                    WS_NAMES+=("$name")
                    WS_FOCUSED+=("$focused")
                    [ "$focused" = "true" ] && CUR_IDX=$idx
                    idx=$((idx + 1))
                done <<< "$parsed_ws"
                ;;
            *)
                echo "[$SCRIPT_NAME]" "Unsupported DESKTOP_SESSION: '$DESKTOP_SESSION'"
                exit 1
                ;;
        esac
    fi
    [ "${#WS_NAMES[@]}" -eq 0 ] && return 1
    return 0
}

item_visual_width() {
    local text="$1"
    local is_focused="$2"
    local len=${#text}
    if [ "$USE_PANGO" = true ]; then
        echo "$len"
    else
        [ "$is_focused" = "true" ] && echo $((len + 1)) || echo "$len"
    fi
}

calc_range_width() {
    local l="$1"
    local r="$2"
    local n=${#WS_NAMES[@]}
    local total=0
    local count=0
    local start_mid=0
    local end_mid=$((n - 1))
    if [ "$l" -gt 1 ]; then
        local foc="false"
        { [ "$CUR_IDX" -eq 0 ] || [ "$CUR_IDX" -eq "$l" ]; } && foc="true"
        total=$((total + $(item_visual_width "${WS_NAMES[0]}...${WS_NAMES[$l]}" "$foc")))
        count=$((count + 1))
        start_mid=$((l + 1))
    fi
    [ "$r" -lt $((n - 2)) ] && end_mid=$((r - 1))
    local i
    for ((i = start_mid; i <= end_mid; i++)); do
        total=$((total + $(item_visual_width "${WS_NAMES[$i]}" "${WS_FOCUSED[$i]}")))
        count=$((count + 1))
    done
    if [ "$r" -lt $((n - 2)) ]; then
        local foc="false"
        { [ "$CUR_IDX" -eq "$r" ] || [ "$CUR_IDX" -eq $((n - 1)) ]; } && foc="true"
        total=$((total + $(item_visual_width "${WS_NAMES[$r]}...${WS_NAMES[$((n - 1))]}" "$foc")))
        count=$((count + 1))
    fi
    [ "$count" -gt 1 ] && total=$((total + count - 1))
    echo "$total"
}

build_visible_items() {
    FINAL_TEXTS=()
    FINAL_FOCUS=()
    local n=${#WS_NAMES[@]}
    local l=0
    local r=$((n - 1))
    local eff_max_width=0
    if [ "$MAX_WIDTH" -gt 0 ]; then
        eff_max_width=$((MAX_WIDTH - ${#PREF} - ${#SUFF}))
        [ "$eff_max_width" -lt 1 ] && eff_max_width=1
    fi
    if [ "$eff_max_width" -gt 0 ] && [ "$(calc_range_width 0 $((n - 1)))" -gt "$eff_max_width" ]; then
        l=$CUR_IDX
        r=$CUR_IDX
        while true; do
            local expanded=false
            if [ "$l" -gt 0 ]; then
                local next_l=$((l - 1))
                [ "$next_l" -eq 1 ] && next_l=0
                if [ "$(calc_range_width "$next_l" "$r")" -le "$eff_max_width" ]; then
                    l=$next_l
                    expanded=true
                fi
            fi
            if [ "$r" -lt $((n - 1)) ]; then
                local next_r=$((r + 1))
                [ "$next_r" -eq $((n - 2)) ] && next_r=$((n - 1))
                if [ "$(calc_range_width "$l" "$next_r")" -le "$eff_max_width" ]; then
                    r=$next_r
                    expanded=true
                fi
            fi
            [ "$expanded" = false ] && break
        done
    fi
    local start_mid=0
    local end_mid=$((n - 1))
    if [ "$l" -gt 1 ]; then
        local foc="false"
        { [ "$CUR_IDX" -eq 0 ] || [ "$CUR_IDX" -eq "$l" ]; } && foc="true"
        FINAL_TEXTS+=("${WS_NAMES[0]}...${WS_NAMES[$l]}")
        FINAL_FOCUS+=("$foc")
        start_mid=$((l + 1))
    fi
    [ "$r" -lt $((n - 2)) ] && end_mid=$((r - 1))
    local i
    for ((i = start_mid; i <= end_mid; i++)); do
        FINAL_TEXTS+=("${WS_NAMES[$i]}")
        FINAL_FOCUS+=("${WS_FOCUSED[$i]}")
    done
    if [ "$r" -lt $((n - 2)) ]; then
        local foc="false"
        { [ "$CUR_IDX" -eq "$r" ] || [ "$CUR_IDX" -eq $((n - 1)) ]; } && foc="true"
        FINAL_TEXTS+=("${WS_NAMES[$r]}...${WS_NAMES[$((n - 1))]}")
        FINAL_FOCUS+=("$foc")
    fi
}

format_element() {
    local el="$1"
    local is_focused="$2"
    if [ "$is_focused" = "true" ]; then
        [ "$USE_PANGO" = true ] && echo "<span background='#00ADD8' foreground='#000000'> ${el} </span>" || echo "${el}*"
    else
        [ "$USE_PANGO" = true ] && echo "<span background='#000000' foreground='#CCFF00'> ${el} </span>" || echo "${el}"
    fi
}

render_output() {
    local indic_output=""
    local sep_styled="|"
    [ "$USE_PANGO" = true ] && sep_styled="<span background='#000000' foreground='#FF1493'>|</span>"
    local i
    for ((i = 0; i < ${#FINAL_TEXTS[@]}; i++)); do
        local el_styled
        el_styled=$(format_element "${FINAL_TEXTS[$i]}" "${FINAL_FOCUS[$i]}")
        if [ -z "$indic_output" ]; then
            indic_output="$el_styled"
        else
            indic_output="${indic_output}${sep_styled}${el_styled}"
        fi
    done
    if [ "$USE_PANGO" = true ]; then
        echo "${PREF}${indic_output}${SUFF}"
    else
        echo "${PREF}${indic_output}${SUFF} "
    fi
}

handle_change() {
    if [ "$IS_DSKTP_MODE" = true ]; then
        local cur_ws_i
        local open_wins_data
        local cur_ws_wins
        local wid_desktop_in_cur_ws
        local wids_desktop_in_other_ws
        cur_ws_i=$(xdotool get_desktop 2>/dev/null)
        open_wins_data=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh")
        cur_ws_wins=$(echo "$open_wins_data" | awk -v ws="$cur_ws_i" '$2 == ws && $7 != "caja.Caja" {print $1}')
        wids_desktop_in_other_ws=$(echo "$open_wins_data" | awk -v ws="$cur_ws_i" '$2 != ws && $7 == "caja.Caja" {print $1}')
        if [ -n "$wids_desktop_in_other_ws" ]; then
            while read -r wid; do
                [ -n "$wid" ] && xdotool windowclose "$wid" 2>/dev/null
            done <<< "$wids_desktop_in_other_ws"
        fi
        wid_desktop_in_cur_ws=$(echo "$open_wins_data" | awk -v ws="$cur_ws_i" '$2 == ws && $7 == "caja.Caja" {print $1}')
        if [ -n "$cur_ws_wins" ]; then
            if [ -n "$wid_desktop_in_cur_ws" ]; then
                while read -r wid; do
                    [ -n "$wid" ] && xdotool windowclose "$wid" 2>/dev/null
                done <<< "$wid_desktop_in_cur_ws"
            fi
        elif [ -z "$wid_desktop_in_cur_ws" ]; then
            case "$DESKTOP_SESSION" in
                i3)
                    i3-msg "exec --no-startup-id caja --no-desktop ~/Desktop"
                    ;;
                *)
                    setsid -f caja --no-desktop ~/Desktop >/dev/null 2>&1
                    ;;
            esac
        fi
        return 0
    fi
    "$HOME/willyhorizont.github.io/linux-debian-lxde/unshow-desktop.sh"
    fetch_workspaces || return 0
    if [ "$IS_NMBRZ_MODE" = true ]; then
        WS_NMS_LEN=$(xdotool get_num_desktops 2>/dev/null)
        python3 "$HOME/willyhorizont.github.io/linux/numrz-wrkspc.py" "${WS_NMS_LEN:-1}"
    fi
    [ "$IS_MGR_MODE" = true ] && return 0
    build_visible_items
    render_output
}

if [ -n "$MOCK_DATA" ]; then
    handle_change
    exit 0
fi

handle_change

TOOLTIP_TXT=$(cat << EOF
$SCRIPT_NAME
click to open wrkspc-mgr.sh
EOF
)
printf "%s" "$TOOLTIP_TXT" 1>&2

DEBOUNCE_PID=""

trigger_debounced() {
    if [ -n "$DEBOUNCE_PID" ]; then
        kill "$DEBOUNCE_PID" 2>/dev/null
    fi
    (
        sleep 0.2
        handle_change
    ) &
    DEBOUNCE_PID=$!
}

case "$DESKTOP_SESSION" in
    LXDE|openbox)
        xprop -root -spy _NET_CURRENT_DESKTOP _NET_NUMBER_OF_DESKTOPS | while read -r _; do
            trigger_debounced
        done
        ;;
    i3)
        i3-msg -t subscribe -m '["workspace", "window"]' 2>/dev/null | while read -r event; do
            if echo "$event" | jq -e '.container.window_properties.class == "Caja"' >/dev/null 2>&1; then
                continue
            fi
            trigger_debounced
        done
        ;;
    *)
        echo "[$SCRIPT_NAME]" "Unsupported DESKTOP_SESSION: '$DESKTOP_SESSION'"
        exit 1
        ;;
esac
