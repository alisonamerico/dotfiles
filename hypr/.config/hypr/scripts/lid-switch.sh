#!/bin/bash
# Handle laptop lid open/close with HDMI awareness
# Usage: lid-switch.sh close | open

MONITOR_HDMI="HDMI-A-2"
MONITOR_LAPTOP="eDP-1"

# Check if HDMI is connected via kernel sysfs
hdmi_connected=0
for conn in /sys/class/drm/card*-HDMI-A-*; do
    [ -e "$conn" ] || continue
    if [ "$(cat "$conn/status" 2>/dev/null)" = "connected" ]; then
        hdmi_connected=1
        break
    fi
done

case "$1" in
    close)
        if [ "$hdmi_connected" -gt 0 ]; then
            # HDMI connected: keep only external monitor
            hyprctl keyword monitor "$MONITOR_LAPTOP, disable" >/dev/null 2>&1
            hyprctl keyword monitor "$MONITOR_HDMI, 1920x1080@120, 0x0, 1" >/dev/null 2>&1
        else
            # No HDMI: suspend
            systemctl suspend
        fi
        ;;
    open)
        # Re-enable laptop screen; activate HDMI if connected
        if [ "$hdmi_connected" -gt 0 ]; then
            hyprctl keyword monitor "$MONITOR_LAPTOP, 1920x1080@60, 0x0, 1" >/dev/null 2>&1
            hyprctl keyword monitor "$MONITOR_HDMI, 1920x1080@120, 0x0, 1" >/dev/null 2>&1
        else
            hyprctl keyword monitor "$MONITOR_HDMI, disable" >/dev/null 2>&1
            hyprctl keyword monitor "$MONITOR_LAPTOP, 1920x1080@60, 0x0, 1" >/dev/null 2>&1
        fi
        ;;
esac
