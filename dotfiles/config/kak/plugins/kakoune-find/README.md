# kakoune-find (and replace)

[kakoune](http://kakoune.org) plugin to search for a pattern in all open buffers, and optionally replace it. Works similarly to `grep.kak`, but does not operate on files.

[![demo](https://asciinema.org/a/160951.png)](https://asciinema.org/a/160951)

## Setup

Add `find.kak` to your autoload dir: `~/.config/kak/autoload/`, or source it manually.

## Usage

### Finding

Call the `find` command. You can specify the pattern as the first argument, otherwise the content of the main selection will be used. From the `*find*` buffer you can jump to the actual match using `<ret>`.

### Replacing

Replacing is done from the `*find*` buffer. Write directly there the changes that you want to make. Then, call `find-apply-changes`: the changes will be applied back to their respective buffers. Any lines that were not modified are simply ignored.

By default, this command only works on open buffers. However, you can specify `-force` to make kakoune temporarily open the file to write the change.

Since the format is the same as [grep.kak's](https://github.com/mawww/kakoune/blob/master/rc/tools/grep.kak), this command can just as well be used from a `*grep*` buffer. Any line that doesn't follow the `<file>:<line>:<column>:<content>` pattern is simply ignored. 

## License

Unlicense
