#!/bin/sh

HDMI_STATUS=$(cat /sys/class/drm/*-HDMI-*/status)

if [ "$HDMI_STATUS" = "connected" ]; then
	echo "set up second screen"
	"$HOME/.dotfiles/scripts/xrandr/dual-screen.sh" left
else
	echo "reset screen layout"
	"$HOME/.dotfiles/scripts/xrandr/reset.sh"
fi
sleep 2
i3-msg 'restart' >/dev/null
