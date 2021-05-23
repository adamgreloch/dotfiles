#!/usr/bin/env bash

# Terminate any currently running instances
killall -q polybar

# Pause while killall completes
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

if type "xrandr" > /dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload dp-left -c ~/.config/polybar/config &
    MONITOR=$m polybar --reload hdmi-left -c ~/.config/polybar/config &
		MONITOR=$m polybar --reload dp-right -c ~/.config/polybar/config &
  done
else
  polybar --reload dp-left -c ~/.config/polybar/config &
  polybar --reload dp-right -c ~/.config/polybar/config &
  polybar --reload hdmi-left -c ~/.config/polybar/config &
fi

echo "polybars launched..."

