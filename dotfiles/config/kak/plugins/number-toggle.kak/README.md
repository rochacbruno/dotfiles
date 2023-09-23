# number-toggle.kak

Toggles between relative and absolute line numbers automatically based on the
current mode. Absolute line numbers are displayed in insert mode, and relative
line numbers are displayed in all other modes.

## Installation

### Using [plug.kak](https://github.com/andreyorst/plug.kak) (recommended)

With plug.kak installed, add to your `kakrc` file:

```kakoune
plug "evanrelf/number-toggle.kak" config %{
  require-module "number-toggle"
}
```

### Manually

Download plugin:

```bash
$ curl -L https://raw.githubusercontent.com/evanrelf/number-toggle.kak/master/rc/number-toggle.kak -o ~/.config/kak/plugins/number-toggle.kak --create-dirs
```

Add to your `kakrc` file:

```kakoune
source ~/.config/kak/plugins/number-toggle.kak
require-module "number-toggle"
```

## Options

- `number_toggle_params` - Line number highlighter parameters (str-list, default
  empty)

```kakoune
# Example of enabling `-hlcursor` and `-separator ' '` parameters
set-option global number_toggle_params -hlcursor -separator ' '
```

## Miscellaneous

Similar plugins for Vim:

- [jeffkreeftmeijer/vim-numbertoggle](https://github.com/jeffkreeftmeijer/vim-numbertoggle)
- [myusuf3/numbers.vim](https://github.com/myusuf3/numbers.vim)
