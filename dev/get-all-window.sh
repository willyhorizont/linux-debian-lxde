#!/bin/bash

TARGET_FILE="$HOME/willyhorizont.github.io/all-window.txt"

RESULT_OUTPUT="wid; wcn_xprop; wcn_xdotool"

for wid in $(xdotool search --name ".*" 2>/dev/null); do
    wcn_xprop=$(xprop -id "$wid" WM_CLASS 2>/dev/null | awk -F '"' '{print $4}')
    wcn_xdotool=$(xdotool getwindowname "$wid" 2>/dev/null)
    cur_ln="$wid; $wcn_xprop; $wcn_xdotool"
    RESULT_OUTPUT="$RESULT_OUTPUT"$'\n'"$cur_ln"
done

mkdir -p "$(dirname "$TARGET_FILE")"
echo "$RESULT_OUTPUT" > "$TARGET_FILE"

echo "=================================================="
echo "Saved to: $TARGET_FILE"

# echo $(xprop -id 60817411 WM_CLASS 2>/dev/null)
# echo $(xprop -id 33554436 WM_CLASS 2>/dev/null)
# echo $(xprop -id 35651588 WM_CLASS 2>/dev/null)

# echo $(xprop -id 60817411 WM_CLASS 2>/dev/null | awk -F '"' '{print $4}')
# echo $(xprop -id 33554436 WM_CLASS 2>/dev/null | awk -F '"' '{print $4}')
# echo $(xprop -id 35651588 WM_CLASS 2>/dev/null | awk -F '"' '{print $4}')

# echo $(xdotool getwindowname 60817411 2>/dev/null)
# echo $(xdotool getwindowname 33554436 2>/dev/null)
# echo $(xdotool getwindowname 35651588 2>/dev/null)

# echo "======================================================"
