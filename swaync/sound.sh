#!/bin/bash
if [ "$(swaync-client -D)" = "false" ]; then
    mpv --no-video --no-terminal ~/.config/swaync/sounds/universfield-new-notification-09-352705.mp3
fi

