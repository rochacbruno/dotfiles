#!/bin/sh

status_line=$(wezterm cli get-text | rg -e "(?:NORMAL|INSERT|SELECT)\s+(\S*)\s[^│]* (\d+):*.*" -o --replace '$1 $2')
filename=$(echo $status_line | awk '{ print $1}')
line_number=$(echo $status_line | awk '{ print $2}')
