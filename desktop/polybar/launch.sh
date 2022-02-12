#!/usr/bin/env bash

# Terminate any currently running instances
killall -q polybar

# Pause while killall completes
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

polybar --reload hdmi-right -c ~/.config/polybar/config &
polybar --reload hdmi-left -c ~/.config/polybar/config &

