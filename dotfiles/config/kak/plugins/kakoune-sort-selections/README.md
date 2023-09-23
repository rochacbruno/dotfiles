# kakoune-sort-selections

[kakoune](http://kakoune.org) plugin to sort selections by their content.

## Setup

Add `sort-selections.kak` to your autoload dir: `~/.config/kak/autoload/`, or source it manually.

## Usage

With multiple selections, call the `sort-selections` command. The selections are sorted lexicographically based on their content. If `-reverse` is specified, their order is... reversed.

If a register is specified (using `-register`), the values in the register will be sorted instead, and the resulting order then applied to the selections.
For example, if you want to do case-insensitive sorting, you can first use `` ` `` to switch selections to lowercase, copy them to the `"` register with `y`, undo with `u` and then call `sort-selections '"'`. Similarly, you can also strip whitespace, convert to ascii...

This plugin also adds the following two commands based on `sort-selections`:

* `reverse-selections`, which is just a shortcut for `sort-selections -reverse -register '#'`. Since `#` is the selection index register, it just works.
* `shuffle-selections`, which randomizes the order of all the current selections.

## Tests

The `test.kak_` file contains tests for the plugin. To execute these tests, simply run `kak -n -e 'source test.kak_ ; quit'`: if the kakoune instance stays open, the tests have somehow failed and the current state can be inspected.


## License

Unlicense
