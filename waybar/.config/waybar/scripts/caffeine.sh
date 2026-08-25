#!/bin/bash

PID_FILE=/tmp/caffeine.pid

is_active() {
    [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

activate() {
    systemd-inhibit --what=idle sleep infinity &
    echo $! > "$PID_FILE"
}

deactivate() {
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm -f "$PID_FILE"
}

case "${1:-}" in
    toggle)
        if is_active; then deactivate; else activate; fi
        ;;
esac

if is_active; then
    printf '{"text":"\uF0F4","class":"active","tooltip":"Caffeine: on"}\n'
else
    rm -f "$PID_FILE"
    printf '{"text":"\uF0F4","class":"inactive","tooltip":"Caffeine: off"}\n'
fi
