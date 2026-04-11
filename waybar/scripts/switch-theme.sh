#!/bin/bash
THEMES_DIR="$HOME/.config/waybar/themes"
CURRENT="$HOME/.config/waybar/.current_theme"

# Read current theme
CURRENT_THEME=$(cat "$CURRENT" 2>/dev/null || echo "pills")

# Cycle to next theme
case "$CURRENT_THEME" in
    pills)   NEXT="minimal" ;;
    minimal) NEXT="centered" ;;
    centered) NEXT="pills" ;;
    *)       NEXT="pills" ;;
esac

# Apply next theme
cp "$THEMES_DIR/$NEXT.css" "$HOME/.config/waybar/style.css"
cp "$THEMES_DIR/$NEXT.json" "$HOME/.config/waybar/config"
echo "$NEXT" > "$CURRENT"

# Restart waybar
killall waybar && waybar &

notify-send "Waybar" "Switched to: $NEXT theme" -t 2000
