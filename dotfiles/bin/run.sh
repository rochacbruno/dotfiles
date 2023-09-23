#!/bin/sh

source status-line.sh
source wezterm-split-pane.sh

program=$(wezterm cli list | awk -v pane_id="$pane_id" '$3==pane_id { print $6 }')
if [ "$program" = "lazygit" ]; then
  echo "q" | wezterm cli send-text --pane-id $pane_id --no-paste
fi

basedir=$(dirname "$filename")
basename=$(basename "$filename")
basename_without_extension="${basename%.*}"
extension="${filename##*.}"

case "$extension" in
  "c")
    run_command="clang -lcmocka -lmpfr -Wall -g -O1 $filename -o $basedir/$basename_without_extension && $basedir/$basename_without_extension"
    ;;
  "go")
    run_command="go run $basedir/*.go"
    ;;
  "md")
    run_command="mdcat -p $filename"
    ;;
  "rkt"|"scm")
    run_command="racket $filename"
    ;;
  "rs")
    run_command="cd $PWD/$(dirname "$basedir"); cargo run; if [ \$status = 0 ]; wezterm cli activate-pane-direction up; end;"
    ;;
  "sh")
    run_command="sh $filename"
    ;;
esac

echo "${run_command}" | wezterm cli send-text --pane-id $pane_id --no-paste
