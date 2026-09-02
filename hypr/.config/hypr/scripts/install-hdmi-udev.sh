#!/bin/bash
# Install the udev rule and systemd sleep hook for HDMI/lid monitor switching
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$SCRIPT_DIR/../udev/99-hdmi-switch.rules"
UDEV_TARGET="/etc/udev/rules.d/99-hdmi-switch.rules"
SLEEP_SCRIPT="$SCRIPT_DIR/system-sleep.sh"
SLEEP_TARGET="/usr/lib/systemd/system-sleep/"
LOGIND_CONF="$SCRIPT_DIR/../systemd/logind.conf.d/lid-monitor.conf"
LOGIND_DIR="/etc/systemd/logind.conf.d"
LOGIND_TARGET="$LOGIND_DIR/lid-monitor.conf"

if [ ! -f "$RULES_FILE" ]; then
    echo "Error: udev rule not found at $RULES_FILE" >&2
    exit 1
fi

echo "Installing udev rule for HDMI monitor switching..."
sudo cp "$RULES_FILE" "$UDEV_TARGET"
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=drm

echo "Installing systemd sleep hook for monitor reconfiguration after resume..."
if [ -f "$SLEEP_SCRIPT" ]; then
    sudo mkdir -p "$SLEEP_TARGET"
    sudo cp "$SLEEP_SCRIPT" "$SLEEP_TARGET"
    sudo chmod +x "$SLEEP_TARGET$(basename "$SLEEP_SCRIPT")"
else
    echo "Warning: $SLEEP_SCRIPT not found, skipping" >&2
fi

echo "Configuring logind to ignore lid switch (monitor-daemon.sh handles it)..."
if [ -f "$LOGIND_CONF" ]; then
    sudo mkdir -p "$LOGIND_DIR"
    sudo cp "$LOGIND_CONF" "$LOGIND_TARGET"
else
    echo "Warning: $LOGIND_CONF not found, skipping" >&2
fi

echo "Done. HDMI hotplug will now automatically switch monitors."
echo "NOTE: lid behavior takes effect once logind reloads; either log out/in,"
echo "      reboot, or run:  sudo systemctl restart systemd-logind"
