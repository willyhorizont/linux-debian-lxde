#!/usr/bin/env bash

CATS="
All
Accessories
Development
Education & Science
Games
Graphics
Internet
Multimedia
Office
Settings
System
Others
"

SUB_ACCESSORIES="Accessories,Utility,Archiving,Compression,TextEditor"
SUB_DEVELOPMENT="Development,Build,Debug,IDE,Profiling,RevisionControl"
SUB_EDUCATION="Education,Science"
SUB_GAMES="Game"
SUB_GRAPHICS="Graphics,Scanning,Photography"
SUB_INTERNET="Internet,Network,Email,FileTransfer,WebBrowser"
SUB_MULTIMEDIA="Multimedia,Player,Audio,Video,Recorder"
SUB_OFFICE="Office,Calendar,Contact,Dictionary,Chart,Finance,Presentation,Spreadsheet,WordProcessor,Publishing,Viewer"
SUB_SETTINGS="Settings,Security,Preferences"
SUB_SYSTEM="System,Emulator,FileManager,TerminalEmulator,Filesystem,Monitor"

WADAH_A=(
    ${SUB_ACCESSORIES//,/ }
    ${SUB_DEVELOPMENT//,/ }
    ${SUB_EDUCATION//,/ }
    ${SUB_GAMES//,/ }
    ${SUB_GRAPHICS//,/ }
    ${SUB_INTERNET//,/ }
    ${SUB_MULTIMEDIA//,/ }
    ${SUB_OFFICE//,/ }
    ${SUB_SETTINGS//,/ }
    ${SUB_SYSTEM//,/ }
)

FILTER_OTHERS=""
for cat in "${WADAH_A[@]}"; do
    FILTER_OTHERS="${FILTER_OTHERS}!${cat},"
done
FILTER_OTHERS="${FILTER_OTHERS%,}"

while true; do
    CHOICE=$(echo "$CATS" | xargs -d '\n' -n 1 | sed -e '/^[[:space:]]*$/d' | rofi -dmenu -p "Categories" -i)

    if [ -z "$CHOICE" ]; then
        exit 0
    fi

    case "$CHOICE" in
        "All")
            FILTER=""
            ;;
        "Accessories")
            FILTER="$SUB_ACCESSORIES"
            ;;
        "Development")
            FILTER="$SUB_DEVELOPMENT"
            ;;
        "Education & Science")
            FILTER="$SUB_EDUCATION"
            ;;
        "Games")
            FILTER="$SUB_GAMES"
            ;;
        "Graphics")
            FILTER="$SUB_GRAPHICS"
            ;;
        "Internet")
            FILTER="$SUB_INTERNET"
            ;;
        "Multimedia")
            FILTER="$SUB_MULTIMEDIA"
            ;;
        "Office")
            FILTER="$SUB_OFFICE"
            ;;
        "Settings")
            FILTER="$SUB_SETTINGS"
            ;;
        "System")
            FILTER="$SUB_SYSTEM"
            ;;
        "Others")
            FILTER="$FILTER_OTHERS"
            ;;
        *)
            exit 0
            ;;
    esac

    if [ -z "$FILTER" ]; then
        rofi -show drun
    else
        rofi -show drun -drun-categories "$FILTER"
    fi
done
