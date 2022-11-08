#!/bin/bash
set -eu

RESOLUTION=$(xrandr -q|sed -n 's/.*current[ ]\([0-9]*\) x \([0-9]*\),.*/\1x\2/p')

# lock the screen
import -silent -window root jpeg:- | convert - -scale 20% -blur 0x2.5 -resize 500% RGB:- | \
    i3lock --raw $RESOLUTION:rgb -i /dev/stdin -e $@
    
# sleep 1 adds a small delay to prevent possible race conditions with suspend
#sleep 1

exit 0
