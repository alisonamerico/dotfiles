#!/bin/bash
# Install the udev rule for HDMI hotplug monitor switching
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$SCRIPT_DIR/../udev/99-hdmi-switch.rules"
TARGET="/etc/udev/rules.d/99-hdmi-switch.rules"

if [ ! -f "$RULES_FILE" ]; then
    echo "Error: udev rule not found at $RULES_FILE" >&2
    exit 1
fi

echo "Installing udev rule for HDMI monitor switching..."
sudo cp "$RULES_FILE" "$TARGET"
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=drm

echo "Done. HDMI hotplug will now automatically switch monitors."
echo "Reboot or run: udevadm trigger --subsystem-match=drm"
