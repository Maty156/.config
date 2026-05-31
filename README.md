# MASU .config

My personal Hyprland desktop configuration. Themed with pywal — colors follow the wallpaper automatically across waybar, rofi, swaync, wofi, dunst, hyprlock, and SDDM.

## Setup

**Hardware:** ThinkPad E531 · 1366×768 · Intel Ivy Bridge  
**OS:** Arch Linux  
**WM:** Hyprland  
**Terminal:** Kitty  
**Shell:** ZSH  

## What's included

| Folder | What it is |
|--------|-----------|
| `hypr/` | Hyprland config, animations, hyprlock, color pipeline scripts |
| `waybar/` | Status bar — pill style, pywal colors |
| `rofi/` | App launcher theme — matches waybar palette |
| `swaync/` | Notification center |
| `kitty/` | Terminal |
| `wofi/` | Secondary launcher (used by some scripts) |
| `wob/` | Volume/brightness OSD |
| `dunst/` | Notification daemon |
| `wal/templates/` | pywal templates for all apps |

## Dependencies

```
hyprland hyprlock hyprpaper awww matuwall
waybar rofi swaync wofi dunst wob
kitty thunar
pywal (python-pywal)
grim slurp
nm-applet blueman
pavucontrol
JetBrainsMono Nerd Font
Papirus-Dark (icon theme)
Bibata-Modern-Classic (cursor)
```

## Install

```bash
# 1. Clone into ~/.config
git clone https://github.com/Maty156/.config.git ~/.config

# 2. Install dependencies (Arch + BlackArch)
sudo pacman -S hyprland hyprlock waybar rofi kitty \
  dunst swaync wob wofi thunar grim slurp \
  nm-applet blueman pavucontrol python-pywal

# 3. Install AUR packages
yay -S hyprpaper awww matuwall \
  ttf-jetbrains-mono-nerd \
  papirus-icon-theme \
  bibata-cursor-theme

# 4. Symlink pywal rofi colors (auto-updates on wallpaper change)
ln -sf ~/.cache/wal/colors-rofi.rasi ~/.config/rofi/colors-rofi.rasi

# 5. Generate initial colors from a wallpaper
wal -i /path/to/your/wallpaper.jpg

# 6. Start Hyprland
Hyprland
```

## How the color pipeline works

When you change wallpaper via matuwall:

```
matuwall → awww-wrapper.sh → wallpaper-colors.sh
                                    ↓
                               wal -i <wallpaper>
                                    ↓
                     ┌─────────────┼──────────────┐
                  waybar        rofi           swaync
                  wofi          dunst          hyprlock
                  wob           hyprland       SDDM
```

`wal-watcher.sh` also runs in the background and catches changes from awww directly.

## Monitor

Configured for `LVDS-1` at `1366x768@60`. Change in `hypr/hyprland.conf`:
```
monitor = LVDS-1, 1366x768@60, 0x0, 1
```
