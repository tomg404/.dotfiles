#!/bin/bash
# stole script from: https://www.reddit.com/r/i3wm/comments/g9qtig/comment/foxd397

export XDG_RUNTIME_DIR=/run/user/$(id -u)

# low and critical battery level.
# at low battery level, notification will be sent to inform the user.
# at critcal battery level, urgent notification will be sent.
# range = 0 - 100
low=15
critical=5

# get battery-level(0-100%) and state(discharging/charging)
battery=$(cat /sys/class/power_supply/BAT0/capacity)
state=$(cat /sys/class/power_supply/BAT0/status)
notified=$(cat /tmp/check-battery-script-notified)
echo $battery
echo $state
echo $notified

if [ "$state" = "Discharging" ] ; then
    # if battery discharging and below low level then send notification
    if [ $battery -gt $critical ] && [ $battery -le $low ] && [ $notified -eq 0 ] ; then
        notify-send -a "Battery" "Low" "Plugin to Recharge" --icon=battery-low
        let notified=1
    # if battery discharging and below critical level then send notification and wait for user action
    elif [ $battery -le $critical ] ; then
        notify-send -a "Battery" "Critically low" "Backup Data or Plugin to Recharge" --icon=battery-low --urgency=critical --wait
    fi
else
    let notified=0
fi
echo $notified > /tmp/check-battery-script-notified

exit 0
