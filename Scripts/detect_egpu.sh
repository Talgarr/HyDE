#!/bin/bash

CONFIG_DIR="$HOME/.config/hypr"
MONITOR_CONFIG_SYMLINK="$CONFIG_DIR/monitors.conf"

MONITOR_INTERNAL_CONFIG="$CONFIG_DIR/monitors-laptop.conf"
MONITOR_EXTERNAL_CONFIG="$CONFIG_DIR/monitors-desktop.conf"

NUM_GPUS=$(ls -1 /dev/dri/card* | wc -l)

if [ "$NUM_GPUS" -gt 1 ]; then
    echo "Multiple GPUs detected. Applying external monitor configuration."
    ln -sf "$MONITOR_EXTERNAL_CONFIG" "$MONITOR_CONFIG_SYMLINK"
else
    echo "Single GPU detected. Applying internal monitor configuration."
    ln -sf "$MONITOR_INTERNAL_CONFIG" "$MONITOR_CONFIG_SYMLINK"
fi
