#!/bin/bash
# Switch Hyprland monitors on HDMI connect/disconnect and lid state changes
# Triggered by udev rule or called at Hyprland startup

MONITOR_HDMI="HDMI-A-2"
MONITOR_LAPTOP="eDP-1"

# Ensure we can talk to Hyprland
if [ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    if [ -n "${XDG_RUNTIME_DIR:-}" ]; then
        export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr/" 2>/dev/null | head -1)
    elif [ -n "${USER:-}" ]; then
        export HYPRLAND_INSTANCE_SIGNATURE=$(ls "/run/user/$(id -u)/hypr/" 2>/dev/null | head -1)
    fi
fi

[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && exit 0

if ! command -v hyprctl &>/dev/null; then
    export PATH="$PATH:/usr/local/bin:/usr/bin"
fi

command -v hyprctl &>/dev/null || exit 0

# Small delay to let Hyprland stabilize (for startup calls)
sleep 0.5

# Check if any HDMI connector is reported as connected by the kernel
hdmi_connected=0
for conn in /sys/class/drm/card*-HDMI-A-*; do
    [ -e "$conn" ] || continue
    status=$(cat "$conn/status" 2>/dev/null)
    if [ "$status" = "connected" ]; then
        hdmi_connected=1
        break
    fi
done

# Check lid state (closed = lid switch triggered or lid is physically closed)
lid_closed=0
for lid_path in /proc/acpi/button/lid/LID0/state /proc/acpi/button/lid/LID/state; do
    if [ -f "$lid_path" ]; then
        if grep -qi "closed" "$lid_path" 2>/dev/null; then
            lid_closed=1
        fi
        break
    fi
done

# Get current Hyprland monitor state
current_hdmi=$(hyprctl monitors 2>/dev/null | grep -c "^Monitor $MONITOR_HDMI")
current_laptop=$(hyprctl monitors 2>/dev/null | grep -c "^Monitor $MONITOR_LAPTOP")

# Determine target state based on lid + HDMI combination
# - Lid closed + HDMI:  only external monitor
# - Lid open + HDMI:    both monitors
# - Lid closed + no HDMI: suspend
# - Lid open + no HDMI:  laptop only
if [ "$hdmi_connected" -gt 0 ]; then
    if [ "$lid_closed" -gt 0 ]; then
        # Lid closed, HDMI connected → only external monitor
        if [ "$current_laptop" -gt 0 ]; then
            hyprctl keyword monitor "$MONITOR_LAPTOP, disable" >/dev/null 2>&1
        fi
        if [ "$current_hdmi" -eq 0 ]; then
            hyprctl keyword monitor "$MONITOR_HDMI, 1920x1080@120, 0x0, 1" >/dev/null 2>&1
        fi
    else
        # Lid open, HDMI connected → both monitors
        if [ "$current_laptop" -eq 0 ]; then
            hyprctl keyword monitor "$MONITOR_LAPTOP, 1920x1080@60, 0x0, 1" >/dev/null 2>&1
        fi
        if [ "$current_hdmi" -eq 0 ]; then
            hyprctl keyword monitor "$MONITOR_HDMI, 1920x1080@120, 0x0, 1" >/dev/null 2>&1
        fi
    fi
else
    # No HDMI connected
    if [ "$lid_closed" -gt 0 ]; then
        # Lid closed, no HDMI → suspend
        systemctl suspend
    else
        # Lid open, no HDMI → laptop only
        if [ "$current_hdmi" -gt 0 ]; then
            hyprctl keyword monitor "$MONITOR_HDMI, disable" >/dev/null 2>&1
        fi
        if [ "$current_laptop" -eq 0 ]; then
            hyprctl keyword monitor "$MONITOR_LAPTOP, 1920x1080@60, 0x0, 1" >/dev/null 2>&1
        fi
    fi
fi
