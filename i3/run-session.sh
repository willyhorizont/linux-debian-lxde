#!/bin/bash

SCRIPT_NAME="run-session.sh"

case 0 in
    $(pgrep -x "i3" >/dev/null; echo $?))
        ;;
    *)
        notify-send "$SCRIPT_NAME" "Error: Session not match!"
        exit 1
        ;;
esac

pkill -9 -f ".*willyhorizont.*run-session.*" 2>/dev/null

CUR_ACTV_WIN_ID=$(xdotool getactivewindow 2>/dev/null)
i3-msg "[id=$CUR_ACTV_WIN_ID] move container to workspace 3"
i3-msg "workspace 3"

i3-msg "workspace 1"
wid_brv=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "brave-browser.Brave-browser" {print $1}' 2>/dev/null)
if [ -z "$wid_brv" ]; then
    i3-msg "exec brave-browser"
fi
while true; do
    wid_brv=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "brave-browser.Brave-browser" {print $1}' 2>/dev/null)
    if [ -n "$wid_brv" ]; then
        break
    fi
    sleep 0.2
done
i3-msg "[id=$wid_brv] move container to workspace 1"

# i3-msg "workspace 2"
# wid_chrm=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "chromium.Chromium" {print $1}' 2>/dev/null)
# if [ -z "$wid_chrm" ]; then
#     i3-msg "exec chromium"
# fi
# while true; do
#     wid_chrm=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "chromium.Chromium" {print $1}' 2>/dev/null)
#     if [ -n "$wid_chrm" ]; then
#         break
#     fi
#     sleep 0.2
# done
# i3-msg "[id=$wid_brv] move container to workspace 2"

i3-msg "workspace 5"
wid_vsc_lxde=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "com.microsoft.vscode.com.microsoft.VSCode" && (index($0, "linux-debian-lxde") || index($0, "linux-debian-lxde | ~/Codes/linux-debian-lxde")) {print $1}' 2>/dev/null)
if [ -z "$wid_vsc_lxde" ]; then
    i3-msg "exec code '$HOME/Codes/linux-debian-lxde/'"
fi
while true; do
    wid_vsc_lxde=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "com.microsoft.vscode.com.microsoft.VSCode" && (index($0, "linux-debian-lxde") || index($0, "linux-debian-lxde | ~/Codes/linux-debian-lxde")) {print $1}' 2>/dev/null)
    if [ -n "$wid_vsc_lxde" ]; then
        break
    fi
    sleep 0.2
done
i3-msg "[id=$wid_vsc_lxde] move container to workspace 5"

i3-msg "workspace 4"
wid_vsc_lnx=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk -v wid_blckls="$wid_vsc_lxde" '$7 == "com.microsoft.vscode.com.microsoft.VSCode" && (index($0, "linux") || index($0, "linux | ~/Codes/linux")) && $1 != wid_blckls {print $1}' 2>/dev/null)
if [ -z "$wid_vsc_lnx" ]; then
    i3-msg "exec code '$HOME/Codes/linux/'"
fi
while true; do
    wid_vsc_lnx=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk -v wid_blckls="$wid_vsc_lxde" '$7 == "com.microsoft.vscode.com.microsoft.VSCode" && (index($0, "linux") || index($0, "linux | ~/Codes/linux")) && $1 != wid_blckls {print $1}' 2>/dev/null)
    if [ -n "$wid_vsc_lnx" ]; then
        break
    fi
    sleep 0.2
done
i3-msg "[id=$wid_vsc_lnx] move container to workspace 4"

i3-msg "workspace 3"
i3-msg "exec pcmanfm '$HOME/Codes/linux-debian-lxde/'"
i3-msg "exec pcmanfm '$HOME/Codes/linux/'"
i3-msg "exec pcmanfm '$HOME/Pictures/Screenshots'"
while true; do
    wid_fm=$("$HOME/willyhorizont.github.io/linux/wmctrl-lxcapg.sh" | awk '$7 == "pcmanfm.Pcmanfm" && $9 != "pcmanfm" {print $1}' 2>/dev/null)
    if [ -n "$wid_fm" ]; then
        break
    fi
    sleep 0.2
done
i3-msg "[class=\"Pcmanfm\"] move container to workspace 3"

i3-msg "workspace 1"
