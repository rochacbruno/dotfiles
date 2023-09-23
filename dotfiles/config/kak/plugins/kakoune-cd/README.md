# kakoune-cd

[kakoune](http://kakoune.org) commands to change or print the working directory.

## Install

Add `cd.kak` to your autoload dir: `~/.config/kak/autoload/`.

Or via [plug.kak](https://github.com/andreyorst/plug.kak):

```
plug 'delapouite/kakoune-cd' %{
  # Suggested mapping
  map global user c ': enter-user-mode cd<ret>' -docstring 'cd'
  # Suggested aliases
  alias global cdb change-directory-current-buffer
  alias global cdr change-directory-project-root
  alias global ecd edit-current-buffer-directory
  alias global pwd print-working-directory
}
```

## Usage

This file provides 4 commands:

- `change-directory-current-buffer`: cd to current buffer dir
- `change-directory-project-root`: cd to root dir (location of`.git` dir in parent dirs)
- `edit-current-buffer-directory`: open an edit prompt in the current buffer directory
- `print-working-directory`: echo `$PWD`

A `cd` mode is also available with a few predefined locations.
Feel free to map your own bookmarks on it.

## See also

- [kakoune-buffers](https://github.com/Delapouite/kakoune-buffers)
- [kakoune-goto-file](https://github.com/Delapouite/kakoune-goto-file)
- [kakoune-edit-or-dir](https://github.com/TeddyDD/kakoune-edit-or-dir)
- [vcs.kak](https://github.com/lenormf/kakoune-extra/blob/master/vcs.kak)

## Licence

MIT
