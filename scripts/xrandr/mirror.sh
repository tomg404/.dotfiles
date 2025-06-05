#!/bin/sh

xrandr \
  --output HDMI-1 --mode 1920x1080 --same-as eDP-1

sleep 2
i3-msg 'restart' >/dev/null
