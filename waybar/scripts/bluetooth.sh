#!/bin/bash

BLUETOOTH=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$BLUETOOTH" = "yes" ]; then
    echo "󰂱"
else
    echo "󰂲"
fi
