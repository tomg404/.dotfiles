#!/bin/sh

# This script provides an easy way to switch
# between screen layouts when a second monitor
# is connected

function print_usage {
  echo "Usage: $0 [top|left|bottom|right]"
  exit 1
}

if [ -z "$1" ]; then
  print_usage
fi

POSITION=$1
case "$POSITION" in
  # +--------+
  # | HDMI-1 |
  # +--------+
  # 
  # +--------+
  # | Laptop |
  # +--------+
  top)
    HDMI_POS='0x0'
    EDP1_POS='0x1080'
    ;;

  # +--------+   +--------+
  # | Laptop |   | HDMI-1 |
  # +--------+   +--------+
  left)
    HDMI_POS='0x0'
    EDP1_POS='1920x0'
    ;;

  # +--------+
  # | Laptop |
  # +--------+
  # +--------+
  # | HDMI-1 |
  # +--------+
  bottom)
    HDMI_POS='0x1080'
    EDP1_POS='0x0'
    ;;

  # +--------+   +--------+
  # | Laptop |   | HDMI-1 |
  # +--------+   +--------+
  right)
    HDMI_POS='1920x0'
    EDP1_POS='0x0'
    ;;
  *)
    print_usage
    ;;
esac

xrandr \
  --output eDP-1 --mode 1920x1080 --pos $EDP1_POS --rotate normal --primary \
  --output HDMI-1 --mode 1920x1080 --pos $HDMI_POS --rotate normal \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output DP-4 --off
