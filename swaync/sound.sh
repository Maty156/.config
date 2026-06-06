#!/usr/bin/env bash
set -euo pipefail

if [ "$(swaync-client -D)" = "false" ]; then
    mpv --no-video --no-terminal ~/.config/swaync/sounds/dragon-studio-new-notification-3-398649.mp3
fi

