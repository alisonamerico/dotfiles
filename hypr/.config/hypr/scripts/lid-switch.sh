#!/bin/bash
# Handle laptop lid open/close with HDMI awareness
# Usage: lid-switch.sh close | open

MONITOR_HDMI="HDMI-A-2"
MONITOR_LAPTOP="eDP-1"

# Hyprland 0.55+ uses Lua config, so monitor changes go through `hyprctl eval`
# (the legacy `hyprctl keyword monitor` no longer works).
mon_off() {
    hyprctl eval "hl.monitor({ output = \"$1\", disabled = true })" >/dev/null 2>&1
}

mon_on() {
    # $1 = monitor, $2 = mode, $3 = position
    hyprctl eval "hl.monitor({ output = \"$1\", mode = \"$2\", position = \"$3\", scale = 1, disabled = false })" >/dev/null 2>&1
}

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
            # HDMI connected: keep only external monitor (at origin)
            mon_off "$MONITOR_LAPTOP"
            mon_on "$MONITOR_HDMI" "1920x1080@120" "0x0"
        else
            # No HDMI: suspend
            systemctl suspend
        fi
        ;;
    open)
        # Re-enable laptop screen; activate HDMI to the right if connected
        if [ "$hdmi_connected" -gt 0 ]; then
            mon_on "$MONITOR_LAPTOP" "1920x1080@60" "0x0"
            mon_on "$MONITOR_HDMI" "1920x1080@120" "1920x0"
        else
            mon_off "$MONITOR_HDMI"
            mon_on "$MONITOR_LAPTOP" "1920x1080@60" "0x0"
        fi
        ;;
esac
