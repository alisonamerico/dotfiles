#!/bin/bash
# Reconfigure monitors + wake screens after system suspend/resume
# Installed to /usr/lib/systemd/system-sleep/ (see install-hdmi-udev.sh flow)
# monitor-daemon.sh re-runs itself as the desktop user when started as root.
case "$1" in
    post)
        # Give the session a moment to come back before talking to Hyprland
        sleep 2
        /home/alison/.config/hypr/scripts/monitor-daemon.sh &
        ;;
esac
exit 0