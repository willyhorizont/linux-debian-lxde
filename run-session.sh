#!/bin/bash

SCRIPT_NAME="run-session.sh"

for pid in $(pgrep -f ".*willyhorizont.*${SCRIPT_NAME}.*"); do
    if [ "$pid" != "$$" ]; then
        kill -9 "$pid" 2>/dev/null
    fi
done

pkill -9 -f ".*willyhorizont.*${SCRIPT_NAME}.*" 2>/dev/null

case "$DESKTOP_SESSION" in
    LXDE|openbox)
        ;;
    i3)
        ;;
    *)
        echo "[$SCRIPT_NAME]" "Unsupported DESKTOP_SESSION: '$DESKTOP_SESSION'"
        exit 1
        ;;
esac

set_ws_nms_len() {
    local ws_nms_len_nu="$1"
    case "$DESKTOP_SESSION" in
        LXDE|openbox)
            xdotool set_num_desktops "$ws_nms_len_nu"
            ;;
    esac
}

mov_cur_win() {
    local wid="$1"
    local tgt_ws_nm="$2"
    case "$DESKTOP_SESSION" in
        LXDE|openbox)
            xdotool set_desktop_for_window "$wid" "$((tgt_ws_nm - 1))"
            ;;
        i3)
            i3-msg "[id=$wid] move container to workspace $tgt_ws_nm"
            ;;
    esac
}

goto_ws() {
    local tgt_ws_nm="$1"
    case "$DESKTOP_SESSION" in
        LXDE|openbox)
            xdotool set_desktop "$((tgt_ws_nm - 1))"
            ;;
        i3)
            i3-msg "workspace $tgt_ws_nm"
            ;;
    esac
}

CUR_ACTV_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
set_ws_nms_len 5
mov_cur_win "$CUR_ACTV_WIN_ID" 3

goto_ws 5
wid_vsc_lxde=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "com.microsoft.vscode.com.microsoft.VSCode" && (index($0, "linux-debian-lxde") || index($0, "linux-debian-lxde | ~/Codes/linux-debian-lxde")) {print $1}' 2>/dev/null)
if [ -z "$wid_vsc_lxde" ]; then
    code "$HOME/Codes/linux-debian-lxde/" &
fi
while true; do
    wid_vsc_lxde=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "com.microsoft.vscode.com.microsoft.VSCode" && (index($0, "linux-debian-lxde") || index($0, "linux-debian-lxde | ~/Codes/linux-debian-lxde")) {print $1}' 2>/dev/null)
    if [ -n "$wid_vsc_lxde" ]; then
        break
    fi
    sleep 0.2
done
set_ws_nms_len 5
# mov_cur_win "$wid_vsc_lxde" 5

goto_ws 4
wid_vsc_lnx=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk -v wid_blckls="$wid_vsc_lxde" '$7 == "com.microsoft.vscode.com.microsoft.VSCode" && (index($0, "linux") || index($0, "linux | ~/Codes/linux")) && $1 != wid_blckls {print $1}' 2>/dev/null)
if [ -z "$wid_vsc_lnx" ]; then
    code "$HOME/Codes/linux/" &
fi
while true; do
    wid_vsc_lnx=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk -v wid_blckls="$wid_vsc_lxde" '$7 == "com.microsoft.vscode.com.microsoft.VSCode" && (index($0, "linux") || index($0, "linux | ~/Codes/linux")) && $1 != wid_blckls {print $1}' 2>/dev/null)
    if [ -n "$wid_vsc_lnx" ]; then
        break
    fi
    sleep 0.2
done
set_ws_nms_len 5
# mov_cur_win "$wid_vsc_lnx" 4

goto_ws 3
pcmanfm "$HOME/Codes/linux-debian-lxde/" &
pcmanfm "$HOME/Codes/linux/" &
pcmanfm "$HOME/Pictures/Screenshots" &
while true; do
    wid_fm=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "pcmanfm.Pcmanfm" && $9 != "pcmanfm" {print $1}' 2>/dev/null)
    if [ -n "$wid_fm" ]; then
        break
    fi
    sleep 0.2
done
set_ws_nms_len 5
# mov_cur_win "$wid_fm" 3

goto_ws 2
# wid_chrm=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "chromium.Chromium" {print $1}' 2>/dev/null)
# if [ -z "$wid_chrm" ]; then
#     chromium &
# fi
# while true; do
#     wid_chrm=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "chromium.Chromium" {print $1}' 2>/dev/null)
#     if [ -n "$wid_chrm" ]; then
#         break
#     fi
#     sleep 0.2
# done
# set_ws_nms_len 5
mov_cur_win "$wid_chrm" 2

goto_ws 1
wid_brv=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "brave-browser.Brave-browser" {print $1}' 2>/dev/null)
if [ -z "$wid_brv" ]; then
    brave-browser &
fi
while true; do
    wid_brv=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "brave-browser.Brave-browser" {print $1}' 2>/dev/null)
    if [ -n "$wid_brv" ]; then
        break
    fi
    sleep 0.2
done
set_ws_nms_len 5
# mov_cur_win "$wid_brv" 1
