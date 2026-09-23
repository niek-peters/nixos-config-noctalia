#!/bin/bash

# Initialize state files
echo "0" > /tmp/tablet_mode_state
echo "0" > /tmp/rotation_lock_state

# 1. Listen to physical tablet-mode switches in the background
libinput debug-events 2>/dev/null | while read -r line; do
    if [[ $line =~ "tablet-mode" ]]; then
        if [[ $line =~ "state 1" ]]; then
            echo "1" > /tmp/tablet_mode_state
        elif [[ $line =~ "state 0" ]]; then
            echo "0" > /tmp/tablet_mode_state
            # Snap back to normal landscape and reset touch transform (0)
            hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", transform = 0 })'
            hyprctl eval 'hl.config({ input = { touchdevice = { transform = 0 } } })'
        fi
    fi
done &

# 2. Listen to accelerometer orientation changes
monitor-sensor | while read -r line; do
    TABLET_MODE=$(cat /tmp/tablet_mode_state 2>/dev/null || echo "0")
    ROTATION_LOCK=$(cat /tmp/rotation_lock_state 2>/dev/null || echo "0")
    
    if [[ $TABLET_MODE -eq 1 ]] && [[ $ROTATION_LOCK -eq 0 ]] && [[ $line =~ "orientation changed:" ]]; then
        orientation=$(echo "$line" | awk '{print $NF}')
        case "$orientation" in
            normal)
                hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", transform = 0 })'
                hyprctl eval 'hl.config({ input = { touchdevice = { transform = 0 } } })'
                ;;
            bottom-up)
                hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", transform = 2 })'
                hyprctl eval 'hl.config({ input = { touchdevice = { transform = 2 } } })'
                ;;
            right-up)
                hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", transform = 3 })'
                hyprctl eval 'hl.config({ input = { touchdevice = { transform = 3 } } })'
                ;;
            left-up)
                hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", transform = 1 })'
                hyprctl eval 'hl.config({ input = { touchdevice = { transform = 1 } } })'
                ;;
        esac
    fi
done