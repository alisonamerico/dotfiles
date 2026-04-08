#!/bin/bash

MONITOR_HDMI="HDMI-A-2"
MONITOR_LAPTOP="eDP-1"

switch_monitor() {
    local hdmi_connected=$(hyprctl monitors all 2>/dev/null | grep -c "^Monitor $MONITOR_HDMI")

    if [ "$hdmi_connected" -gt 0 ]; then
        hyprctl keyword monitor "$MONITOR_LAPTOP,disable"
        hyprctl keyword monitor "$MONITOR_HDMI,1920x1080@60,0x0,1"
    else
        hyprctl keyword monitor "$MONITOR_HDMI,disable"
        hyprctl keyword monitor "$MONITOR_LAPTOP,1920x1080@60,0x0,1"
    fi
}

switch_monitor

while true; do
    sleep 5
    switch_monitor
done
