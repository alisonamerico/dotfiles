#!/bin/bash

VPN_IFACES=()

for iface in /sys/class/net/*; do
    name=$(basename "$iface")
    case "$name" in
        tun*|wg*|tailscale*|zt*)
            VPN_IFACES+=("$name")
            ;;
    esac
done

if [ ${#VPN_IFACES[@]} -gt 0 ]; then
    printf '{"text":"\uF023","class":"active","tooltip":"VPN: %s"}\n' "${VPN_IFACES[*]}"
else
    printf '{"text":"","class":"inactive"}\n'
fi
