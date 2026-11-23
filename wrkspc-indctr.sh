#!/bin/bash

SHOW_WINS=false
REVERSE_ORDER=false
USE_PANGO=false
MAX_WIDTH=0
MOCK_DATA=""
PREF=""
SUFF=""

while [[ $# -gt 0 ]]; do
    case "$1" in
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
        local cur_wrkspc
        local tot_wrkspc
        local ls_ws
        local max_active_win_ws
        local max_valid_ws
        local needed_tot_wrkspc
        # tot_wrkspc=$(wmctrl -d | grep -c .)
        # cur_wrkspc=$(wmctrl -d | awk '{if ($2 == "*") print $1}')
        tot_wrkspc=$(xdotool get_num_desktops 2>/dev/null)
        cur_wrkspc=$(xdotool get_desktop 2>/dev/null)
        ls_ws=$("$HOME/willyhorizont.github.io/linux/get-open-wins.sh" | awk '{print $2}')

        max_active_win_ws=-1
        if [ -n "$ls_ws" ]; then
            max_active_win_ws=$(echo "$ls_ws" | sort -nu | tail -n 1)
        fi

        if [ "$cur_wrkspc" -gt "$max_active_win_ws" ]; then
            max_valid_ws=$cur_wrkspc
        else
            max_valid_ws=$max_active_win_ws
        fi

        if [ "$max_valid_ws" -lt 0 ]; then
            max_valid_ws=0
        fi

        needed_tot_wrkspc=$((max_valid_ws + 1))
        if [ "$tot_wrkspc" -ne "$needed_tot_wrkspc" ]; then
            xdotool set_num_desktops "$needed_tot_wrkspc"
            tot_wrkspc="$needed_tot_wrkspc"
        fi

        local start_loop end_loop step
        if [ "$REVERSE_ORDER" = true ]; then
            start_loop=$((tot_wrkspc - 1))
            end_loop=0
            step=-1
        else
            start_loop=0
            end_loop=$((tot_wrkspc - 1))
            step=1
        fi

        local i open_wins_count display_i el
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

            if [ "$open_wins_count" -eq 0 ] && [ "$i" -ne "$cur_wrkspc" ]; then
                continue
            fi

            display_i=$((i + 1))
            if [ "$SHOW_WINS" = true ]; then
                el="${open_wins_count}wins@ws${display_i}"
            else
                el="${display_i}"
            fi

            WS_NAMES+=("$el")
            if [ "$i" -eq "$cur_wrkspc" ]; then
                WS_FOCUSED+=("true")
                CUR_IDX=$idx
            else
                WS_FOCUSED+=("false")
            fi
            idx=$((idx + 1))
        done
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
    fetch_workspaces || return 0
    build_visible_items
    render_output
}

if [ -n "$MOCK_DATA" ]; then
    handle_change
    exit 0
fi

if ! command -v wmctrl &> /dev/null || ! command -v xprop &> /dev/null || ! command -v xdotool &> /dev/null; then
    echo "Error: missing dependencies 'wmctrl xprop xdotool'"
    exit 1
fi

TOOLTIP_TXT=$(cat << EOF
wrkspc-indctr.sh
click to open wrkspc-mgr.sh
EOF
)
printf "%s" "$TOOLTIP_TXT" 1>&2

handle_change

xprop -root -spy _NET_CURRENT_DESKTOP | while read -r _; do
    handle_change
done
