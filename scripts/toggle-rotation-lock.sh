#!/bin/bash
LOCK_FILE="/tmp/rotation_lock_state"
CURRENT=$(cat "$LOCK_FILE" 2>/dev/null || echo "0")

if [[ "$CURRENT" -eq 1 ]]; then
    echo "0" > "$LOCK_FILE"
    noctalia msg notification-show "Rotation Lock -- Unlocked"
else
    echo "1" > "$LOCK_FILE"
    noctalia msg notification-show "Rotation Lock -- Locked"
fi