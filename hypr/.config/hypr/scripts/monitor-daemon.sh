#!/bin/bash

MONITOR_HDMI="HDMI-A-2"
MONITOR_LAPTOP="eDP-1"

switch_monitor() {
    local hdmi_status=$(hyprctl monitors all 2>/dev/null | grep -c "$MONITOR_HDMI")

    if [ "$hdmi_status" -gt 0 ]; then
        hyprctl keyword monitor "$MONITOR_LAPTOP,disable" 2>/dev/null
        hyprctl keyword monitor "$MONITOR_HDMI,preferred,0x0,1" 2>/dev/null
    else
        hyprctl keyword monitor "$MONITOR_HDMI,disable" 2>/dev/null
        hyprctl keyword monitor "$MONITOR_LAPTOP,preferred,0x0,1" 2>/dev/null
    fi
}

sleep 3
switch_monitor
