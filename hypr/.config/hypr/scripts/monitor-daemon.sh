#!/bin/bash
# Switch Hyprland monitors on HDMI connect/disconnect and lid state changes
# Triggered by udev rule, systemd sleep hook, or called at Hyprland startup

MONITOR_HDMI="HDMI-A-2"
MONITOR_LAPTOP="eDP-1"

# Exit cleanly on TERM/INT so systemd doesn't wait 90s at shutdown.
# The script holds an flock on /tmp; releasing it promptly is critical.
trap 'exit 0' TERM INT

# udev and systemd run us as root with no Hyprland env, so the instance
# signature lookup below fails (it would search /run/user/0/hypr). Re-run
# ourselves as the desktop user so hyprctl can reach the compositor.
if [ "$(id -u)" -eq 0 ]; then
    exec /usr/bin/runuser -u alison -- env HOME=/home/alison USER=alison \
        XDG_RUNTIME_DIR=/run/user/1000 "$0" "$@"
fi

# Serialize concurrent invocations (autostart + udev fire the same script in
# parallel on boot; without a lock each one re-launches waybar, leaving two
# bars). Use non-blocking flock: if another instance holds the lock, exit
# immediately instead of blocking (which keeps /tmp busy and breaks reboot).
exec 9>/tmp/monitor-daemon.lock
flock -n 9 || exit 0
# Close fd 9 after acquiring the lock so it doesn't hold /tmp open.
# The lock is released when the script exits; closing early avoids the
# "Failed unmounting /tmp" error at shutdown.
exec 9>&-

# Ensure we can talk to Hyprland
if [ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    for dir in "${XDG_RUNTIME_DIR:-}" /run/user/1000 /run/user/$(id -u); do
        [ -n "$dir" ] || continue
        sig=$(ls "$dir/hypr/" 2>/dev/null | head -1)
        if [ -n "$sig" ]; then
            export HYPRLAND_INSTANCE_SIGNATURE="$sig"
            export XDG_RUNTIME_DIR="$dir"
            break
        fi
    done
fi

[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && exit 0

export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

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

# HPC is a helper that bounds every hyprctl call so the script can never hang
# waiting on the compositor during shutdown (hyprctl would otherwise block
# once Hyprland is gone, holding our flock open on /tmp).
HPC() { timeout 5 hyprctl "$@"; }

# Get current Hyprland monitor state
current_hdmi=$(HPC monitors 2>/dev/null | grep -c "^Monitor $MONITOR_HDMI")
current_laptop=$(HPC monitors 2>/dev/null | grep -c "^Monitor $MONITOR_LAPTOP")

# Hyprland 0.55+ uses Lua config, so monitor changes go through `hyprctl eval`
# (the legacy `hyprctl keyword monitor` no longer works).
mon_off() {
    HPC eval "hl.monitor({ output = \"$1\", disabled = true })" >/dev/null 2>&1
}

mon_on() {
    # $1 = monitor, $2 = mode, $3 = position
    HPC eval "hl.monitor({ output = \"$1\", mode = \"$2\", position = \"$3\", scale = 1, disabled = false })" >/dev/null 2>&1
}

# Determine target state based on lid + HDMI combination
# - Lid closed + HDMI:  only external monitor
# - Lid open + HDMI:    both monitors
# - Lid closed + no HDMI: suspend
# - Lid open + no HDMI:  laptop only
if [ "$hdmi_connected" -gt 0 ]; then
    if [ "$lid_closed" -gt 0 ]; then
        # Lid closed, HDMI connected → only external monitor (HDMI at origin)
        if [ "$current_laptop" -gt 0 ]; then
            mon_off "$MONITOR_LAPTOP"
        fi
        if [ "$current_hdmi" -eq 0 ]; then
            mon_on "$MONITOR_HDMI" "1920x1080@120" "0x0"
        fi
    else
        # Lid open, HDMI connected → both monitors (HDMI to the right of laptop)
        if [ "$current_laptop" -eq 0 ]; then
            mon_on "$MONITOR_LAPTOP" "1920x1080@60" "0x0"
        fi
        if [ "$current_hdmi" -eq 0 ]; then
            mon_on "$MONITOR_HDMI" "1920x1080@120" "1920x0"
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
            mon_off "$MONITOR_HDMI"
        fi
        if [ "$current_laptop" -eq 0 ]; then
            mon_on "$MONITOR_LAPTOP" "1920x1080@60" "0x0"
        fi
    fi
fi

# Wake all active screens (some stay in DPMS standby after resume/hotplug)
HPC eval 'hl.dsp.dpms("on")' >/dev/null 2>&1

# Waybar can lose its layer surface when outputs change (e.g. HDMI unplug),
# leaving no bar at all. Restart it so it re-attaches to the active monitors.
# Runs unconditionally so waybar is also brought back if it died on hotplug.
# No condition on pgrep: in that case waybar is gone and the check would
# wrongly skip the restart, which is exactly the bug we're fixing.
# Relaunch via hyprctl so waybar runs in the compositor's environment
# (WAYLAND_DISPLAY etc.) — a bare `waybar &` fails when udev/systemd call us.
pkill -x waybar 2>/dev/null
sleep 1
HPC dispatch 'hl.dsp.exec_cmd("waybar")' >/dev/null 2>&1

# Re-wake screens: some GPUs blank outputs briefly while Hyprland reconfigures
sleep 1
HPC eval 'hl.dsp.dpms("on")' >/dev/null 2>&1
