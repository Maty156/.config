#!/bin/bash
# MASU Modern Waybar Theme Switcher - v4.0
# Supports config, config.json, and config.jsonc

THEMES_DIR="$HOME/.config/waybar/themes"
CURRENT_FILE="$HOME/.config/waybar/.current_theme"
LOG="$HOME/.config/waybar/theme-switch.log"
CONFIG_DEST="$HOME/.config/waybar/config"
STYLE_DEST="$HOME/.config/waybar/style.css"

# Get only valid themes (folders that have a style.css and AT LEAST ONE config variant)
mapfile -t VALID_THEMES < <(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | while read -r dir; do
    if [[ -f "$THEMES_DIR/$dir/style.css" ]] && \
       ([[ -f "$THEMES_DIR/$dir/config" ]] || [[ -f "$THEMES_DIR/$dir/config.json" ]] || [[ -f "$THEMES_DIR/$dir/config.jsonc" ]]); then
        echo "$dir"
    fi
done)

if [[ ${#VALID_THEMES[@]} -eq 0 ]]; then
    notify-send "❌ Waybar" "No valid themes found in $THEMES_DIR" -u critical
    exit 1
fi

CURRENT_THEME=$(cat "$CURRENT_FILE" 2>/dev/null || echo "${VALID_THEMES[0]}")

# Find current index
CURRENT_INDEX=-1
for i in "${!VALID_THEMES[@]}"; do
    if [[ "${VALID_THEMES[$i]}" == "$CURRENT_THEME" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done
[[ $CURRENT_INDEX -eq -1 ]] && CURRENT_INDEX=0

NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#VALID_THEMES[@]} ))
NEXT_THEME="${VALID_THEMES[$NEXT_INDEX]}"
THEME_PATH="$THEMES_DIR/$NEXT_THEME"

echo "$(date '+%H:%M:%S') Switching: $CURRENT_THEME → $NEXT_THEME" >> "$LOG"

# 1. Apply config (check variants in priority)
if [[ -f "$THEME_PATH/config.jsonc" ]]; then
    cp "$THEME_PATH/config.jsonc" "$CONFIG_DEST"
elif [[ -f "$THEME_PATH/config.json" ]]; then
    cp "$THEME_PATH/config.json" "$CONFIG_DEST"
elif [[ -f "$THEME_PATH/config" ]]; then
    cp "$THEME_PATH/config" "$CONFIG_DEST"
fi

# 2. Apply style
cp "$THEME_PATH/style.css" "$STYLE_DEST"

echo "$NEXT_THEME" > "$CURRENT_FILE"


# Restart Waybar
pkill waybar
sleep 0.2
waybar &>/dev/null &

notify-send "󰔎 Waybar Theme" "Switched to <b>$NEXT_THEME</b>" -t 2000 -a "Waybar System"

echo "✓ Active: $NEXT_THEME" >> "$LOG"

