#!/bin/bash

export XDG_RUNTIME_DIR=/run/user/$(id -u)

notify-send "Test Notification" "hello from cron :)"
notify-send --urgency=critical "Test Notification" "Do something. NOW!" 