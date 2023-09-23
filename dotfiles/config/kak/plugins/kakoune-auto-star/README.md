# kakoune-auto-star

[kakoune](http://kakoune.org) plugin to auto-fill search register if empty.

## Install

Add `auto-star.kak` to your autoload dir: `~/.config/kak/autoload/`.

## Usage

Start a vanilla kakoune and press `n`. What happens? It yells at you
in the status bar: `no search pattern`! At the beginning, the search register
is empty and this key can't do anything.

So, as the name implies, `auto-star` will perform a `*` before `n`, `N`, `<a-n>`
and `<a-N>` to avoid this frustration.

## See Also

- [kakoune-auto-percent](https://github.com/Delapouite/kakoune-auto-percent)

## Licence

MIT
