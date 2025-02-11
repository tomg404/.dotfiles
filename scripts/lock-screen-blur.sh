#!/bin/sh

SCREENSHOT_PATH="/tmp/i3lock-scrot-screencapture.png"

# make screenshot
scrot --overwrite \
    --silent \
    --quality 1 \
    --file "$SCREENSHOT_PATH"

convert "$SCREENSHOT_PATH" \
    -resize 10% \
    -blur 0x1 \
    -resize 1000% \
    -gravity center \
    -font "FiraCode-Nerd-Font-Mono-Reg" \
    -pointsize 26 \
    -fill white \
    -annotate +0+160 "Type Password to Unlock" \
    "$SCREENSHOT_PATH"

i3lock -i "$SCREENSHOT_PATH"