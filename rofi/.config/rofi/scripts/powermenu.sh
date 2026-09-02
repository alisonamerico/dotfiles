#!/bin/bash

# Power menu for rofi

OPTIONS="Lock\nLogout\nReboot\nShutdown"

CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -p "Power" -theme ~/.config/rofi/style-3.rasi)

case "$CHOSEN" in
    Lock)
        hyprlock
        ;;
    Logout)
        hyprctl dispatch "hl.dsp.exit()"
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
