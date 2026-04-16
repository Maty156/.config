#!/bin/bash

export LD_PRELOAD=/usr/lib/libgtk4-layer-shell.so
cd ~/.config/matuwall/
source venv/bin/activate

# Get current wallpaper BEFORE opening matuwall
OLD_WALL=$(awww query 2>/dev/null | grep -Eo '/.*\.(jpg|jpeg|png|webp)')

# Launch / toggle matuwall
matuwall --toggle 2>/dev/null

if [ $? -ne 0 ]; then
    matuwall &
fi
# Wait until wallpaper actually changes (with timeout safety)
TIMEOUT=10
COUNT=0

while true; do
    sleep 0.5
    COUNT=$((COUNT + 1))

    NEW_WALL=$(awww query 2>/dev/null | grep -Eo '/.*\.(jpg|jpeg|png|webp)' | head -n 1)

    # If wallpaper changed → proceed
    if [[ -n "$NEW_WALL" && "$NEW_WALL" != "$OLD_WALL" ]]; then
        echo "New wallpaper detected: $NEW_WALL"

        wal -i "$NEW_WALL" -n -q

        cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors.css 2>/dev/null
        cp ~/.cache/wal/colors-wofi.css ~/.config/wofi/style.css 2>/dev/null

        hyprctl reload

        # WAYBAR FIX (safe restart)
        killall waybar 2>/dev/null
        while pgrep -x waybar >/dev/null; do sleep 0.2; done
        waybar >/dev/null 2>&1 &

        # SWAYNC FIX
        killall swaync 2>/dev/null
        while pgrep -x swaync >/dev/null; do sleep 0.2; done
        swaync >/dev/null 2>&1 &

        break
    fi

    # Timeout safety (prevents infinite loop)
    if [ "$COUNT" -gt "$((TIMEOUT * 2))" ]; then
        echo "Timeout waiting for wallpaper change"
        break
    fi
done
