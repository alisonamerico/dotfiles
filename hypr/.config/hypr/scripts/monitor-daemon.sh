#!/bin/bash

# Script para gerenciar monitores automaticamente
# Detecta laptop fechado e monitor HDMI conectado

MONITOR_HDMI="HDMI-A-1"
MONITOR_LAPTOP="eDP-1"

switch_monitor() {
    # Verifica se HDMI está conectado
    if hyprctl monitors all | grep -q "$MONITOR_HDMI"; then
        # HDMI conectado - usar apenas HDMI (laptop fica desabilitado)
        hyprctl keyword monitor "$MONITOR_LAPTOP,disable" 2>/dev/null
    else
        # HDMI desconectado - usar apenas laptop
        hyprctl keyword monitor "$MONITOR_HDMI,disable" 2>/dev/null
        hyprctl keyword monitor "$MONITOR_LAPTOP,preferred,0x0,1" 2>/dev/null
    fi
}

# Esperar sistema detectar monitores
sleep 2

# Executar uma vez na inicialização
switch_monitor
