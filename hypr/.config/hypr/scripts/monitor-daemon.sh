#!/bin/bash

MONITOR_HDMI="HDMI-A-2"
MONITOR_LAPTOP="eDP-1"

switch_monitor() {
    local hdmi_connected=$(hyprctl monitors all 2>/dev/null | grep -c "^Monitor $MONITOR_HDMI")

    if [ "$hdmi_connected" -gt 0 ]; then
        hyprctl eval "hl.monitor({ output = \"$MONITOR_LAPTOP\", disabled = true })" >/dev/null
        hyprctl eval "hl.monitor({ output = \"$MONITOR_HDMI\", disabled = false, mode = \"1920x1080@120\", position = \"0x0\", scale = 1 })" >/dev/null
    else
        hyprctl eval "hl.monitor({ output = \"$MONITOR_HDMI\", disabled = true })" >/dev/null
        hyprctl eval "hl.monitor({ output = \"$MONITOR_LAPTOP\", disabled = false, mode = \"1920x1080@60\", position = \"0x0\", scale = 1 })" >/dev/null
    fi
}

switch_monitor

if [ "$1" != "--once" ]; then
    while true; do
        sleep 5
        switch_monitor
    done
fi
