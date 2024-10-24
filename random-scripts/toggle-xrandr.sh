#!/bin/sh

HDMI_STATUS=$(cat /sys/class/drm/*-HDMI-*/status)

if [ "$HDMI_STATUS" = "connected" ]; then
	echo "execute dock.sh"
	sh "$HOME/.screenlayout/dock.sh"
	i3-msg 'restart' >/dev/null
else
	echo "execute standard.sh"
	sh "$HOME/.screenlayout/standard.sh"
fi
