# kakoune-mark

_Mark_ is an extension to the [kakoune](https://kakoune.org) editor that allows
highlighting all occurrences of one or several words in different colors.

![Demo](https://gitlab.com/fsub/kakoune-mark/uploads/cdc3690cc3534e6fb2ebc16b652fc30a/kakoune-mark-demo.gif)

## Requirements

- Some non-ancient version of the [_kakoune_](https://kakoune.org) editor
- A POSIX compliant [_shell_](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/sh.html)
- _printf_ (see, for example, [GNU Core Utilities](https://www.gnu.org/software/coreutils/))

## Installation

Add `mark.kak` to your autoload directory `${XDG_CONFIG_HOME}/kak/autoload` or
any subfolder. (`${XDG_CONFIG_HOME}` defaults to `${HOME}/.config`.)

## Basic Usage

Place the cursor over a word. In normal mode, enter `:mark-word<ret>`. All
occurrences of the word under the cursor are highlighted in each window.
By repeating these steps, it is possible to mark multiple words. The mechanism
automatically assigns different colors. If all color slots are full, the one
that is longest occupied is reused. As a side effect, the word that was
originally associated with this slot loses its highlighting.

A word can be unmarked in the same way as it was marked: place the cursor over
one occurrence and execute `mark-word`.

In order to unmark all words at once, call `mark-clear`.

## Customization

To simplify matters, we recommend that you define shortcuts for the above
commands. For example, you can put the following lines in your configuration
file `${XDG_CONFIG_HOME}/kak/kakrc`:

- `map global user m :mark-word<ret>`
- `map global user M :mark-clear<ret>`

The word under the cursor can then be marked or unmarked simply by entering
the key sequence `<space>m`. Similarly, all highlights can be removed by
typing `<space>M`.

(Please note that the binding of custom mappings has changed from `,` to
`<space>` since [kakoune 2022.10.31](https://github.com/mawww/kakoune/releases/tag/v2022.10.31).)

## Related Work

This project was inspired by [Ingo Karkat](https://github.com/inkarkat)'s
[vim](https://www.vim.org) plugin [Mark](https://github.com/inkarkat/vim-mark).

## Acknowledgment

Many thanks to [Maxime Coste](https://github.com/mawww) for creating and
sharing [kakoune](https://github.com/mawww/kakoune). Chapeau!

## Permissions and Restrictions

[UNLICENSE](https://unlicense.org)
