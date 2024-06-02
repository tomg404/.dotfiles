#!/bin/bash
# adapted script from: https://www.reddit.com/r/i3wm/comments/g9qtig/comment/foxd397

# necessary for dunst
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# settings. low / critical battery thresholds (range: 0-100)
low=15
critical=5
icon_path="/usr/share/icons/Papirus/48x48/status/battery-low.svg"

# check for tmp file existence
tmp_file_path="/tmp/check-battery-script-notified"
if [ ! -f "$tmp_file_path" ] ; then
  echo "Creating tmp file..."
  echo "0" > "$tmp_file_path"
fi

# get battery level(0-100%), state(discharging/charging) and if user was already notified
battery=$(cat /sys/class/power_supply/BAT0/capacity)
state=$(cat /sys/class/power_supply/BAT0/status)
notified=$(cat "$tmp_file_path")
# echo "Battery percentage: $battery%" # comment out to not spam journalctl
# echo "Battery state: $state"         #
# echo "Already notified: $notified"   #

# notification logic
if [ "$state" = "Discharging" ] ; then
    
  # if battery discharging and below low level then send notification
  if [ $battery -gt $critical ] && [ $battery -le $low ] && [ $notified -eq 0 ] ; then
    dunstify --appname="Battery" --icon="$icon_path" "Low" "Plugin to Recharge"
    let notified=1

  # if battery discharging and below critical level then send notification and wait for user action
  elif [ $battery -le $critical ] ; then
    dunstify --appname="Battery" --icon="$icon_path" --urgency=critical --wait "Critically low" "Backup Data or Plugin to Recharge"
    
  fi

else
    
  let notified=0

fi
echo "$notified" > "$tmp_file_path"

exit 0
