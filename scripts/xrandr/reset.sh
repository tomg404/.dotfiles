#!/bin/sh

# Turn off all HDMI/DP connections
xrandr \
  --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
  --output HDMI-1 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output DP-4 --off
