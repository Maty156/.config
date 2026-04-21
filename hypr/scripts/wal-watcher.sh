#!/bin/bash
# wal-watcher.sh — watches awww for wallpaper changes and runs pywal

LAST_WALL=""

while true; do
    CURRENT=$(awww query 2>/dev/null | grep -oP '(?<=image: ).*')

    if [ -n "$CURRENT" ] && [ "$CURRENT" != "$LAST_WALL" ] && [ -f "$CURRENT" ]; then
        echo "Wallpaper changed: $CURRENT"
        LAST_WALL="$CURRENT"

        # Generate new colors with pywal
        wal -i "$CURRENT" -n -q

        # Copy colors to all apps
        [ -f ~/.cache/wal/colors-waybar.css ] && cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors.css
        [ -f ~/.cache/wal/colors-wofi.css ] && cp ~/.cache/wal/colors-wofi.css ~/.config/wofi/style.css
        [ -f ~/.cache/wal/colors.css ] && cp ~/.cache/wal/colors.css ~/.config/swaync/colors.css
        [ -f ~/.cache/wal/wob.ini ] && cp ~/.cache/wal/wob.ini ~/.config/wob/wob.ini
        [ -f ~/.cache/wal/dunstrc ] && cp ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc
        [ -f ~/.cache/wal/hyprland-colors.conf ] && cp ~/.cache/wal/hyprland-colors.conf ~/.config/hypr/hyprland-colors.conf

        bash ~/.config/hypr/scripts/hyprlock_wall.sh "$CURRENT"
        sudo cp "$CURRENT" /usr/share/sddm/themes/catppuccin/backgrounds/current-wall.jpg 2>/dev/null
        bash ~/.config/hypr/scripts/sddm-colors.sh

        hyprctl reload 2>/dev/null

        # Restart other components
        pkill -x waybar
        pkill dunst 2>/dev/null; dunst &
        pkill wob 2>/dev/null
        rm -f /tmp/wobpipe
        mkfifo /tmp/wobpipe
        tail -f /tmp/wobpipe | wob -c ~/.config/wob/wob.ini &

        # === Critical part for Swaync ===
        echo "Restarting swaync with new colors..."
        pkill -x swaync
        sleep 0.5                    # Give it time to fully die + file to be written
        swaync &                     # Start fresh with new colors.css

        sleep 0.6                    # Wait for new swaync to initialize
        swaync-client -R -rs 2>/dev/null || true
        swaync-client -df 2>/dev/null || true   # Ensure DND is off
    fi

    sleep 1
done
