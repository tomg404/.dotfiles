#!/bin/sh

speed=$(sensors | grep fan1 | awk '{print $2; exit}')

if [ "$speed" != "" ]; then
    printf "%srpm" "$speed"
else
   echo "n/a"
fi
