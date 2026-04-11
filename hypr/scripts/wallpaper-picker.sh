#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers"

SELECTED=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | \
    while read -r file; do
        name=$(basename "$file")
        echo -en "$name\0icon\x1f$file\n"
    done | rofi -dmenu -p "Wallpaper" \
    -theme ~/.config/rofi/config.rasi \
    -show-icons \
    -icon-size 100 \
    -kb-accept-entry "Return" \
    -i)

if [ -n "$SELECTED" ]; then
    ~/.config/hypr/scripts/wallpaper.sh "$WALLPAPER_DIR/$SELECTED"
fi
