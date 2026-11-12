#!/bin/bash

REVERSE_ORDER=false
USE_PANGO=false
MAX_WIDTH=0
MOCK_DATA=""
PREF=""
SUFF=""

while [[ $# -gt 0 ]]; do
    case "$1" in
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
    fi

    [ "${#WS_NAMES[@]}" -eq 0 ] && return 1
    return 0
}

item_visual_width() {
    local text="$1"
    local is_focused="$2"
    local len=${#text}
    if [ "$USE_PANGO" = true ]; then
        echo $((len + 2))
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
    fetch_workspaces || return
    build_visible_items
    render_output
}

if [ -n "$MOCK_DATA" ]; then
    handle_change
    exit 0
fi

if ! command -v i3-msg &> /dev/null || ! command -v jq &> /dev/null; then
    echo "Error: missing dependencies 'i3-msg jq'"
    exit 1
fi

TOOLTIP_TXT=$(cat << EOF
wrkspc-indctr.sh
click to run wrkspc-mgr.sh --goto
EOF
)
printf "%s" "$TOOLTIP_TXT" 1>&2

handle_change

i3-msg -t subscribe -m '[ "workspace" ]' 2>/dev/null | while read -r _; do
    handle_change
done
