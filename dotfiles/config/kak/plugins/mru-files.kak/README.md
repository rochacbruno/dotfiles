# Kakoune mru-files plugin

## _Persist most recently used files between sessions_

This [Kakoune](https://github.com/mawww/kakoune/) plugin gives you easy access to **file history**, as in `vim`'s `:oldfiles` (or similar plugins). Also included:
- **session management**: save / restore currently open buffers. See `mru-files-session-save`.
- **command history** persistence. See [`kakhist`](kakhist).
- a reusable **library of shell functions** that may avoid the need to call external commands in pure-shell modules and facilitates Kakoune / shell integration. See [`k9s0ke-shlib`](k9s0ke-shlib).

## Install

If using [`plug.kak`](https://github.com/andreyorst/plug.kak):
```
plug 'https://gitlab.com/kstr0k/mru-files.kak.git' %{
  # optional customization: set these *before* plugin loads
  #set global mru_files_history %sh{echo "$HOME/.local/share/kak/mru.txt"}
} demand mru-files %{  # %{} needed even if empty
  # suggested mappings: *after* plugin loads
  # think "go alt[ernate]-f[iles]"
  map global goto <a-f> '<esc>: mru-files ' -docstring 'mru-files'
  map global goto <a-F> '<esc>: mru-files-related<ret>' -docstring 'mru-files-related'
}
# optional: enable kakhist (see kakhist/README.md)
```
Manual installation: place somewhere in `autoload`, and `require-module mru-files` in `kakrc`.

If you've installed `mru-files` before, please review the [changelog](CHANGELOG.md).

## Usage

With the plugin loaded, any visit to a file (saved or not) is recorded in the MRU history. The implementation is such that the [cost](#implementation) should be minimal.

See [`kakhist`](kakhist) instructions to enable / use it.

### Commands

- `mru-files-list` brings up a '`*mru*`' buffer with a list of most recently used files. Press `<ret>` on any line to open the file (`<a-ret>`: open in the background, to ease opening several files). You can modify the buffer and press `>` to update the history file (e.g. to get rid of unwanted entries).
- `mru-files` lets you select a recent file using completion; if nothing is selected (no arguments), calls `mru-files-list`
- `mru-files-related`: move to the top of `*mru*` files "related" (path-wise) to the most recent one. From the `*mru*` buffer, press "=" to group files related to the one under cursor. This does *not* change the MRU history files (unless you *update them using "`>`"*), i.e. re-running `mru-files` will resurrect the chronological order.
- `mru-files-session-save [file]` saves the files currently being edited to a session file (option `mru_files_session_file`). To restore the buffers, source the file (or use the next command). By default (`mru_files_session_autosave = true`), the session auto-saves whenever a client exits.
- `mru-files-session-load [file]` sources the session (or specified) file
- `mru-files-disable` unregisters all hooks
- `mru_files_{history2tmp,tmp2history}`: request explicit sync to / from persistent storage; will not replace a newer file with an older version

#### Nth most recent / cycling

Both `mru-files` and `mru-files-list` honor an optional count (given directly, e.g. `4 :mru-files`, or received from a mapping). If a count is present, the `N'th` most recent file will be opened directly. This implies that you can cycle between the three most recent files (for example) by repeatedly typing `3:<ret>` in normal mode.

### Configuration

Some options should be changed *before* `require-module`, or before `demand` if using `plug`.
- `mru_files_ignore_sh`: `sh` code to test if file (available as "$1") should be excluded. By default, excludes `*/.git/[A-Z]*`. The code is translated to a function body, so it can be as simple as `! test -s "$1"` (ignore empty files) or as complex as several code blocks (wrap in `%{}` to simplify quoting). The option is appendable (you can `set global -add mru_files_ignore_sh %{ # your code here }`). [`*_ignore_sh` options](kakhist/#ignore_sh) are further discussed in `kakhist`.
- `mru_files_debug = true` will turn on `set -x` and thus fill the `*debug*` buffer with `sh` trace messages. More usefully, it can show problems with user-supplied code (such as above)
- `mru_files_max = 20` (the default, you may want to increase it)
- `mru_files_history`: path to persistent history file (by default inside `$HOME/.config/kak`)
- `mru_files_history_tmp`: path to "temporary" (i.e. in fast storage, e.g. under `/tmp`) history file. It gets copied to `mru_files_history` upon exit. By default `kakoune-tmp/mru_files.txt` in `$XDG_RUNTIME_DIR`, with sensible fallbacks. Change this to keep separate histories for the current session / window.
- `mru_files_session_file`: path to session file (`~/.local/share/kak/mru/mru_files_session.kak`)
- `mru_files_session_autosave`: auto-save session whenever a client exits (default: true)

## Implementation

The plugin adds a `WinDisplay` hook. That hook updates (actually, sets an idle hook to update) `mru_files_history_tmp`, so no writes to potentially slow / fragile storage &mdash; until you exit, and the file gets synchronized to `mru_files_history`.


## Copyright

`Alin Mr. <almr.oss@outlook.com>` / MIT license
