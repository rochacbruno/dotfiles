# grep-write.kak

This plugin is designed as the "replace" part of kakoune's "find & replace" workflow.

Special thanks to [occivink][1] for creating [kakoune-find][2] where this was implemented. (I just trimmed it to my preference)

## Installation

### With [cork.kak][3]

The recommended way to install **grep-write.kak** is to use [cork.kak][3] plugin manager.

To install **grep-write.kak** with [cork.kak][3] add this to your `kakrc`:

``` kak
cork grep-write https://github.com/JacobTravers/grep-write.kak
```

### With [plug.kak][4]

To install **grep-write.kak** with [plug.kak][4] add this to your `kakrc`:
``` kak
plug "JacobTravers/grep-write.kak"
```


## Finding

Call the builtin [`grep`][5] command.

## Replacing

Write the edits you would like to make in the `*grep*` buffer. Then, call `grep-write` and the changes will be applied to their respective files.

Any lines that were not modified are simply ignored.

(Upon completion it reports the # of changes applied and ignored)

## License

Unlicense



[1]: https://github.com/occivink
[2]: https://github.com/occivink/kakoune-find
[3]: https://github.com/topisani/cork.kak
[4]: https://github.com/andreyorst/plug.kak
[5]: https://github.com/mawww/kakoune/blob/master/rc/tools/grep.kak
