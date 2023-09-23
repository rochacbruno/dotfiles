![Tug](images/tug.png)

# Shell Commands For The [Kakoune](https://kakoune.org) Editor

**`:mv [target]`** - Move the current file and rename the buffer

**`:rename [target]`** - Rename the current file (keeping it in the same directory)

**`:cp [target]`** - Copy the current file

**`:mkdir`** - Make directories for the current buffer

**`:chmod [mode]`** - Change file modes or Access Control Lists

**`:rm`** - Remove the current file and buffer


## Installation

    plug "matthias-margush/tug"


## [Connect.kak](https://github.com/alexherbo2/connect.kak) Integration

**`bin/tmv`** - Move files, also renaming associated buffers in the connected editor

To install, add `tmv` to your PATH:

    export PATH="$PATH:${XDG_CONFIG_HOME:-$HOME/.config}/kak/plugins/tug/bin"


## [nnn](https://github.com/jarun/nnn) Integration

    ln -s ~/.config/kak/plugins/tug/config/nnn/plugins/tmv ~/.config/nnn/plugins/tmv
    export NNN_PLUG='m:tmv'

([people-clipart png from pngtree.com](https://pngtree.com/so/people-clipart))

