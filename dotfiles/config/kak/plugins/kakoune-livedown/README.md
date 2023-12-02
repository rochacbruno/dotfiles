# kakoune-livedown

[kakoune](http://kakoune.org) plugin to live preview markdown files with [livedown](https://github.com/shime/livedown)

## Install

Add `livedown.kak` to your autoload dir: `~/.config/kak/autoload/`.

Or via [plug.kak](https://github.com/andreyorst/plug.kak):

```
plug 'delapouite/kakoune-livedown'
```

`livedown` must be installed on your system:

```
$ npm install -g livedown
```

## Usage

`livedown-start` runs a livedown process in the background listening on PORT `livedown_port` option.
Your default browser is launched to display the current buffer file rendered to HTML.

`livedown-start-with-write-on-idle` runs `livedown-start` and additionally sets up hooks
to write the buffer on `InsertIdle` and `NormalIdle` for immediate feedback.

Use `livedown-stop` to kill the background process and remove any idle hooks associated with the buffer.

## See also

- [vim-livedown](https://github.com/shime/vim-livedown)
- [markdown.kak](https://github.com/mawww/kakoune/blob/master/rc/filetype/markdown.kak)

## Licence

MIT
