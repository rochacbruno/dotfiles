#!/bin/bash
status=`xset -q | grep 'DPMS is' | awk '{ print $3 }'`
if [ $status == 'Enabled' ]; then
    xset -dpms && \
    dunstify 'Screen suspend is disabled.'
else
   	    xset +dpms && \
    dunstify 'Screen suspend is enabled.'
fi
