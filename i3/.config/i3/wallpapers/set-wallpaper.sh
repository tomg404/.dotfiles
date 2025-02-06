#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file-name>"
  echo "The file has to be base64 encoded"
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "Error: Could not read file $1"
  exit 1
fi

WALLPAPER_B64="$1"
WALLPAPER=$(mktemp)

base64 -d "$WALLPAPER_B64" > "$WALLPAPER" 2> /dev/null
if [ $? -ne 0 ]; then
  echo "Error: Could not decode file $1"
  rm "$WALLPAPER"
  exit 1
fi

feh --no-fehbg --bg-scale "$WALLPAPER"
rm "$WALLPAPER"
