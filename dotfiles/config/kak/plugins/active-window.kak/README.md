# Active-window
[Kakoune](https://kakoune.org/) text editor plugin.

Cursor is colored only in the active window. Inactive windows have grey cursor.

[Watch demo](https://asciinema.org/a/315721)

## Installation
With [plug](https://github.com/andreyorst/plug.kak):

`plug 'greenfork/active-window.kak'`

## Options
Customize `InactiveCursor` face:

`set-face global InactiveCursor default,rgb:5d5d5d`

## Using with tmux
Add this option to your `.tmux.conf`:
```
# Allow using FocusIn and FocusOut hooks
set-option -g focus-events on
```

## License
Unlicense. See LICENSE file.
