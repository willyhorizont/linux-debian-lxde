#!/usr/bin/env bash

while true; do
    CHOICE=$(printf "%b\n" \
        "lxterminal\0icon\x1fterminal" \
        "pcmanfm\0icon\x1fsystem-file-manager" \
        "firefox\0icon\x1ffirefox" \
        "vivaldi\0icon\x1fvivaldi" \
        "brave\0icon\x1fbrave-browser" \
        "chromium\0icon\x1fchromium" \
        "vscode\0icon\x1fvisual-studio-code" \
        "all\0icon\x1fpreferences-system-windows" \
        | rofi -dmenu -p "Run" -show-icons -i)

    if [ -z "$CHOICE" ]; then
        exit 0
    fi

    case "$CHOICE" in
        "all")
            rofi -show drun
            if [ $? -eq 0 ]; then
                exit 0
            fi
            ;;
        "lxterminal")
            lxterminal & exit 0 ;;
        "pcmanfm")
            pcmanfm & exit 0 ;;
        "firefox")
            firefox & exit 0 ;;
        "vivaldi")
            vivaldi & exit 0 ;;
        "brave")
            brave-browser & exit 0 ;;
        "chromium")
            chromium & exit 0 ;;
        "vscode")
            code & exit 0 ;;
        *)
            $CHOICE & exit 0 ;;
    esac
done
