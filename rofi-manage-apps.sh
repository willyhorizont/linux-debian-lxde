#!/usr/bin/env bash

FAV_APPS_LIST_FILE_PATH="$HOME/willyhorizont.github.io/.config/fav-apps.txt"

FAV_APPS=()
if [ -f "$FAV_APPS_LIST_FILE_PATH" ]; then
    while read -r line || [ -n "$line" ]; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        FAV_APPS+=("${line//[[:space:]]/}")
    done < "$FAV_APPS_LIST_FILE_PATH"
fi

CACHE_DIR="$HOME/.cache/rofi"
CACHE_FILE="$CACHE_DIR/apps-list-${XDG_CURRENT_DESKTOP:-default}.cache"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --clear-cache)
            rm -f "$CACHE_FILE"
            echo "[rofi-manage-apps.sh] cache cleared!"
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

validate_and_get_metadata() {
    local filepath="$1"
    if grep -q "^NoDisplay=true" "$filepath"; then
        return 1
    fi
    if grep -q "^OnlyShowIn=" "$filepath"; then
        local only_show_in
        only_show_in=$(grep "^OnlyShowIn=" "$filepath" | cut -d'=' -f2 | tr ';' '\n')
        local match=0
        while read -r cur_session; do
            if [ "$cur_session" = "$XDG_CURRENT_DESKTOP" ]; then
                match=1
                break
            fi
        done <<EOF
$only_show_in
EOF
        if [ $match -eq 0 ]; then
            return 1
        fi
    fi
    if grep -q "^NotShowIn=" "$filepath"; then
        local not_show_in
        not_show_in=$(grep "^NotShowIn=" "$filepath" | cut -d'=' -f2 | tr ';' '\n')
        while read -r cur_session; do
            if [ "$cur_session" = "$XDG_CURRENT_DESKTOP" ]; then
                return 1
            fi
        done <<EOF
$not_show_in
EOF
    fi
    local app_name
    app_name=$(grep -m1 "^Name=" "$filepath" | cut -d'=' -f2)
    [ -z "$app_name" ] && app_name=$(basename "$filepath" .desktop)
    local icon_name
    icon_name=$(grep -m1 "^Icon=" "$filepath" | cut -d'=' -f2)
    [ -z "$icon_name" ] && icon_name="application-x-desktop"
    echo "${app_name}|${icon_name}"
    return 0
}

find_desktop_file() {
    local file_name="$1"
    if [ -f "$HOME/.local/share/applications/${file_name}.desktop" ]; then
        echo "$HOME/.local/share/applications/${file_name}.desktop"
    elif [ -f "/usr/share/applications/${file_name}.desktop" ]; then
        echo "/usr/share/applications/${file_name}.desktop"
    fi
}

generate_app_list_raw() {
    declare -A printed_apps
    for app in "${FAV_APPS[@]}"; do
        local desktop_path
        desktop_path=$(find_desktop_file "$app")
        if [ -n "$desktop_path" ]; then
            local app_metadata
            if app_metadata=$(validate_and_get_metadata "$desktop_path"); then
                local display_name="${app_metadata%%|*}"
                local icon_name="${app_metadata#*|}"
                printf "%s\0icon\x1f%s\x1finfo\x1f%s\n" "$display_name" "$icon_name" "$app"
                printed_apps["$app"]=1
            fi
        fi
    done
    declare -A processed_files
    for desktop_shortcut_dir in "$HOME/.local/share/applications/" "/usr/share/applications/"; do
        [ -d "$desktop_shortcut_dir" ] || continue
        while read -r filepath; do
            local filename
            filename=$(basename "$filepath")
            local file_name_with_ext="${filename%.desktop}"
            [[ -n "${processed_files[$filename]}" ]] && continue
            processed_files[$filename]=1
            [[ -n "${printed_apps[$file_name_with_ext]}" ]] && continue
            local app_metadata
            if app_metadata=$(validate_and_get_metadata "$filepath"); then
                local display_name="${app_metadata%%|*}"
                local icon_name="${app_metadata#*|}"
                echo "${display_name}|${icon_name}|${file_name_with_ext}"
            fi
        done < <(find "$desktop_shortcut_dir" -name "*.desktop" -type f 2>/dev/null)
    done | sort -f | while read -r line; do
        local display_name="${line%%|*}"
        local remainder="${line#*|}"
        local icon_name="${remainder%%|*}"
        local file_name="${remainder#*|}"
        printf "%s\0icon\x1f%s\x1finfo\x1f%s\n" "$display_name" "$icon_name" "$file_name"
    done
}

get_app_list() {
    mkdir -p "$CACHE_DIR"
    local cur_mtime=0
    for dir in "$HOME/.local/share/applications" "/usr/share/applications"; do
        if [ -d "$dir" ]; then
            local dir_mtime
            dir_mtime=$(stat -c %Y "$dir" 2>/dev/null || echo 0)
            cur_mtime=$((cur_mtime + dir_mtime))
        fi
    done
    
    if [ -f "$FAV_APPS_LIST_FILE_PATH" ]; then
        local fav_mtime
        fav_mtime=$(stat -c %Y "$FAV_APPS_LIST_FILE_PATH" 2>/dev/null || echo 0)
        cur_mtime=$((cur_mtime + fav_mtime))
    fi

    if [ -f "$CACHE_FILE" ]; then
        local cache_mtime
        cache_mtime=$(head -n 1 "$CACHE_FILE")
        if [ "$cur_mtime" -eq "$cache_mtime" ] 2>/dev/null; then
            tail -n +2 "$CACHE_FILE"
            return
        fi
    fi
    echo "$cur_mtime" > "$CACHE_FILE"
    generate_app_list_raw >> "$CACHE_FILE"
    tail -n +2 "$CACHE_FILE"
}

if [ -z "$1" ]; then
    get_app_list
else
    TARGET_APP="${ROFI_INFO:-$1}"
    coproc (gtk-launch "$TARGET_APP" > /dev/null 2>&1 || "$TARGET_APP" > /dev/null 2>&1)
    exit 0
fi
