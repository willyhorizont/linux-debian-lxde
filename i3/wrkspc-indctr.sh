#!/bin/bash

if ! command -v i3-msg &> /dev/null || ! command -v jq &> /dev/null; then
    echo "Error: missing dependencies 'i3-msg jq'"
    exit 1
fi

REVERSE_ORDER=false
USE_PANGO=false

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
        *)
            shift
            ;;
    esac
done

TOOLTIP_TXT=$(cat << EOF
 wrkspc-indctr.sh
 click to run wrkspc-mgr.sh --goto;
EOF
)

printf "%s" "$TOOLTIP_TXT" 1>&2

handle_change() {
    local ws_data
    ws_data=$(i3-msg -t get_workspaces 2>/dev/null)
    if [ -z "$ws_data" ]; then
        return
    fi
    local parsed_ws
    parsed_ws=$(echo "$ws_data" | jq -r '.[] | "\(.name) \(.focused)"')
    if [ "$REVERSE_ORDER" = true ]; then
        parsed_ws=$(echo "$parsed_ws" | tac)
    fi
    local indic_output=""
    while read -r name focused; do
        if [ -z "$name" ]; then continue; fi
        local el="$name"
        local el_styled=""
        if [ "$focused" = "true" ]; then
            if [ "$USE_PANGO" = true ]; then
                el_styled="<span background='#00ADD8' foreground='#000000'> ${el} </span>"
            else
                el_styled="${el}*"
            fi
        else
            if [ "$USE_PANGO" = true ]; then
                el_styled="<span background='#000000' foreground='#CCFF00'> ${el} </span>"
            else
                el_styled="${el}"
            fi
        fi
        if [ -z "$indic_output" ]; then
            indic_output="$el_styled"
        else
            if [ "$USE_PANGO" = true ]; then
                local sep_styled="<span background='#000000' foreground='#FF1493'>|</span>"
                indic_output="${indic_output}${sep_styled}${el_styled}"
            else
                indic_output="${indic_output} | ${el_styled}"
            fi
        fi
    done <<< "$parsed_ws"
    if [ "$USE_PANGO" = true ]; then
        echo "$indic_output"
    else
        echo "$indic_output "
    fi
}

handle_change

i3-msg -t subscribe -m '[ "workspace" ]' 2>/dev/null | while read -r _; do
    handle_change
done
