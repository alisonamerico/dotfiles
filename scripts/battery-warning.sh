#!/usr/bin/env bash
set -euo pipefail

BAT="/sys/class/power_supply/BAT1"
FLAG_DIR="/tmp/battery-warning"

mkdir -p "$FLAG_DIR"

notify() {
    local urgency=$1 icon=$2 title=$3 body=$4
    notify-send -u "$urgency" -i "$icon" "$title" "$body"
}

while true; do
    if [[ ! -f "$BAT/status" ]]; then
        sleep 60
        continue
    fi

    status=$(cat "$BAT/status")
    capacity=$(cat "$BAT/capacity")

    if [[ "$status" == "Discharging" ]]; then
        rm -f "$FLAG_DIR/level100"
        if [[ "$capacity" -le 3 ]]; then
            notify critical "battery-caution" "BATERIA CRÍTICA" "Desligando em 30 segundos..."
            sleep 30
            systemctl hibernate
        elif [[ "$capacity" -le 5 ]] && [[ ! -f "$FLAG_DIR/level5" ]]; then
            notify critical "battery-caution" "Bateria muito baixa" "${capacity}% - Hibernando em breve"
            touch "$FLAG_DIR/level5"
            rm -f "$FLAG_DIR/level10" "$FLAG_DIR/level20"
        elif [[ "$capacity" -le 10 ]] && [[ ! -f "$FLAG_DIR/level10" ]]; then
            notify normal "battery-low" "Bateria baixa" "${capacity}% - Conecte o carregador"
            touch "$FLAG_DIR/level10"
            rm -f "$FLAG_DIR/level20"
        elif [[ "$capacity" -le 20 ]] && [[ ! -f "$FLAG_DIR/level20" ]]; then
            notify normal "battery" "Bateria descarregando" "${capacity}% restante"
            touch "$FLAG_DIR/level20"
        fi
    else
        rm -f "$FLAG_DIR"/level5 "$FLAG_DIR"/level10 "$FLAG_DIR"/level20
        if [[ "$capacity" -ge 100 ]] && [[ ! -f "$FLAG_DIR/level100" ]]; then
            notify normal "battery_charged" "Bateria 100%" "Bateria totalmente carregada. Pode desconectar o carregador."
            touch "$FLAG_DIR/level100"
        fi
    fi

    sleep 30
done
