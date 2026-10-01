#!/bin/bash
# Waybar VPN indicator with per-provider brand icons.
#
# - Detects VPNs by network interface name prefix (proton0, tailscale0, ...).
# - Generic interfaces (tun0, tun1, ...) are attributed to a provider by the
#   VPN client process that is running (pritunl-client-service, proton daemon,
#   mullvad-daemon, ...), since the interface name alone is not identifying.
# - Renders the real brand logo when available via the "Simple Icons" font
#   (install it once with install-simple-icons-font.sh).
# - Falls back to Nerd Font symbols when the font is missing.
# - Multiple connected VPNs are all shown, side by side.
#
# Provider table: pattern|slug|simple-icons-codepoint|nerd-codepoint|color|label
#   simple-icons codepoint = glyph in the Simple Icons font (v16.4.0).
#   nerd codepoint         = fallback glyph (Nerd Font), used when the Simple
#                            Icons font is missing or the brand has no logo
#                            there (e.g. pritunl).

PROVIDERS=(
    'proton*|protonvpn|f308|f023|6D4AFF|Proton VPN'
    'tailscale*|tailscale|f52d|f023|9AA0A6|Tailscale'
    'wg*|wireguard|f6b8|f023|88171A|WireGuard'
    'mullvad*|mullvad|f15a|f023|294D73|Mullvad'
    'surfshark*|surfshark|f50b|f023|1EBFBF|Surfshark'
    'zt*|zerotier|f714|f023|FFB441|ZeroTier'
    'nordlynx|nordvpn|f1b8|f023|4687FF|NordVPN'
    'pritunl*|pritunl||f132|0093DD|Pritunl'
)

# Generic tun* interfaces attributed by a running client + confirmed connection
# state (daemons alone are not enough: they run even when disconnected).
#   process-pattern|slug|status-command|status-regex
#   (empty status-regex => rely on the status-command's exit code)
PROCESS_SLUGS=(
    'pritunl-client|pritunl|pritunl-client list|\bActive\b'
    'mullvad-daemon|mullvad|mullvad status|Connected'
    'tailscaled|tailscale|tailscale ip -4|'
    'zerotier-one|zerotier|zerotier-cli listnetworks| OK'
)

# join_by <sep> <words...> — joins arguments with a multi-char separator.
join_by() {
    local d="$1" out="" sep="" x
    shift
    for x in "$@"; do out+="$sep$x"; sep="$d"; done
    printf '%s' "$out"
}

declare -A SEEN
declare -a ICONS=() TIPS=() GENERIC=()

mapfile -t IFACES < <(ls /sys/class/net | grep -E '^(tun|wg|proton|tailscale|mullvad|surfshark|zt|pritunl|nordlynx)' || true)

FONT_OK=0
fc-list 2>/dev/null | grep -i 'Simple Icons' >/dev/null && FONT_OK=1

# add_provider <slug> <iface-label> — renders one icon per provider (deduped).
add_provider() {
    local slug="$1" iflabel="$2"
    [[ -n "${SEEN[$slug]:-}" ]] && return 0
    local entry pat s sicon nerd color label
    for entry in "${PROVIDERS[@]}"; do
        IFS='|' read -r pat s sicon nerd color label <<< "$entry"
        [[ "$s" == "$slug" ]] || continue
        SEEN[$slug]=1
        if ((FONT_OK)) && [[ -n "$sicon" ]]; then
            ICONS+=("<span font='Simple Icons' foreground='#$color'>&#x$sicon;</span>")
        else
            ICONS+=("<span foreground='#$color'>&#x$nerd;</span>")
        fi
        TIPS+=("$label ($iflabel)")
        return 0
    done
}

for name in "${IFACES[@]}"; do
    matched=0
    for entry in "${PROVIDERS[@]}"; do
        IFS='|' read -r pat slug sicon nerd color label <<< "$entry"
        [[ "$name" == $pat ]] || continue
        add_provider "$slug" "$name"
        matched=1
        break
    done
    ((matched)) || GENERIC+=("$name")
done

# Generic tun* interfaces: attribute to a running VPN client if recognized.
if ((${#GENERIC[@]})); then
    gen_ifaces="$(join_by ', ' "${GENERIC[@]}")"
    attributed=0
    for entry in "${PROCESS_SLUGS[@]}"; do
        IFS='|' read -r procpat slug stcmd statuspat <<< "$entry"
        if pgrep -f "$procpat" >/dev/null 2>&1; then
            cmd="${stcmd%% *}"
            if command -v "$cmd" >/dev/null 2>&1; then
                if [[ -n "$statuspat" ]]; then
                    $stcmd 2>/dev/null | grep -qE "$statuspat"
                else
                    $stcmd >/dev/null 2>&1
                fi
                if (( $? == 0 )); then
                    add_provider "$slug" "$gen_ifaces"
                    attributed=1
                fi
            fi
        fi
    done
    if ((attributed)); then
        GENERIC=()
    fi
fi

# Unidentified VPN interfaces (e.g. OpenVPN tun0) still show the lock icon.
if ((${#GENERIC[@]})); then
    ICONS+=("<span>&#xF023;</span>")
fi

if ((${#ICONS[@]})); then
    text="${ICONS[*]}"
    PARTS=()
    ((${#TIPS[@]})) && PARTS+=("$(join_by ', ' "${TIPS[@]}")")
    if ((${#GENERIC[@]})); then
        PARTS+=("não identificada ($(join_by ', ' "${GENERIC[@]}"))")
    fi
    tooltip="VPN ativa: $(join_by '; ' "${PARTS[@]}")"
    printf '{"text":"%s","tooltip":"%s","class":"active"}\n' "$text" "$tooltip"
else
    printf '{"text":"","class":"inactive"}\n'
fi