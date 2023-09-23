# `kakhist`

## _History UI and persistent history for `kakoune`_

`kakhist` adds **persistent command history** support to [Kakoune](https://github.com/mawww/kakoune/). It loads previous history when `kak` starts, and saves it back to a history file when `kak` exits. Histories from **concurrent sessions** will not clobber each other when saved back to disk, because the plugin only appends new commands from each session to the history file.

## Install

`kakhist` is part of [`mru-files.kak`](https://gitlab.com/kstr0k/mru-files.kak.git), but is independent of `mru-files` functionality. Assuming all `mru-files.kak` components (`kakhist` requires [`k9s0ke-shlib`](../k9s0ke-shlib)) are available in autoload, e.g. by using `plug` as suggested in the `mru-files.kak` documentation, add
```
# maybe customize kakhist_*: max, file, ignore_sh etc
require-module kakhist; kakhist-init
# suggested mappings
map global goto ':' '<esc>: kakhist-buf-show<ret>' \
  -docstring 'show command history'
```
to `kakrc`. This will load the module, load the command history file, set up hooks to save the history when exiting, and map "`g:`" to functionality similar to `vim`'s "`q:`".

## Usage

If installed as suggested, history will automatically be loaded when starting `kak` and saved when exiting.

### Commands

- `kakhist-buf-show` displays command history in a `*kakhist*` buffer. Press `<ret>` on any line to execute a previous command.
- `kakhist-load`, `kakhist-save` load / save history manually; not normally required (or advised for `-load`)

### Options

- `kakhist_file`: path to history file, by default `$KAKOUNE_CONFIG/kakhist.txt`
- `kakhist_max`: maximum number of entries to save (LIFO)
- `kakhist_ignore_sh`: sh code that returns success (0) if command (`"$1"`) should NOT be saved. It is translated to a function body. See below.

### `ignore_sh`

By default `quit`-related commands are ignored. You can replace the default value of `kakhist_ignore_sh` or append to it. If you append, the default code sets `$2` to be the command name stripped of all arguments and any final "`!`". To keep the code appendable, `return 0` to ignore, but call false (without returning) to keep the command. Example:
```
set -add global kakhist_ignore_sh %{
case "$2" in
  pwd) return 0 ;;
esac; false
}
```
is appendable (rejects `:pwd`), but the simpler `%{ test "$2" = pwd }`, while equivalent, is not.

#### Ignoring a regex

Use anchors ("`^$`") as needed. Note that you should use "`&&`" (not "`||`") so that the fall-through case is equivalent to `false`:
```
set -add global kakhist_ignore_sh %{
test -n "$(printf %s "$1" | sed -ne '/ignore.*me/p')" &&
  return 0
}
```

## Implementation

`kakhist-load` / `save` add a "magic" marker to the command history (register "`:`") to delimit "loaded" history (which should not be saved again) from "new" history (which will be appended to the history file).

## See also

- [kakoune-state-save](https://gitlab.com/Screwtapello/kakoune-state-save)

## Copyright

`Alin Mr. <almr.oss@outlook.com>` / MIT license
