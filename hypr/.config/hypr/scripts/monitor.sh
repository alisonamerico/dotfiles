#!/bin/bash

# Script para gerenciar monitores automaticamente
# Usado quando o monitor HDMI é conectado/desconectado

MONITOR_HDMI="HDMI-A-1"
MONITOR_LAPTOP="eDP-1"

handle_monitors() {
    if hyprctl monitors all | grep -q "$MONITOR_HDMI"; then
        # HDMI conectado - desabilitar laptop, usar apenas HDMI
        hyprctl keyword monitor "$MONITOR_LAPTOP,disable"
        hyprctl keyword monitor "$MONITOR_HDMI,1920x1080@120,0x0,1"
    else
        # HDMI desconectado - habilitar laptop
        hyprctl keyword monitor "$MONITOR_HDMI,disable"
        hyprctl keyword monitor "$MONITOR_LAPTOP,1920x1080@60,0x0,1"
    fi
}

# Executar imediatamente
handle_monitors
