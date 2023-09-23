#!/bin/sh

source wezterm-split-pane.sh
wezterm cli activate-pane-direction --pane-id $pane_id down

program=$(wezterm cli list | awk -v pane_id="$pane_id" '$3==pane_id { print $6 }')
if [ "$program" = "lazygit" ]; then
    wezterm cli activate-pane-direction down
else
    echo "lazygit" | wezterm cli send-text --pane-id $pane_id --no-paste
fi
