#!/bin/bash
if pgrep -x "wvkbd-mobintl" > /dev/null; then
    # If it's already running, toggle its visibility state
    pkill -SIGRTMIN wvkbd-mobintl
# else
#     # Launch it freshly with your preferred sizing and layout
#     wvkbd-mobintl --non-exclusive
fi