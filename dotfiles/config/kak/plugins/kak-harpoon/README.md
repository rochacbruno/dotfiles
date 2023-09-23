# kak-harpoon

Quickly save and switch between your most important Kakoune files. Harpoons are
saved on editor shutdown and are restored depending on the current working
directory and active Git branch of the session.

Inspired by [Harpoon](https://github.com/ThePrimeagen/harpoon) for Neovim.

[![asciicast](https://asciinema.org/a/MH4yLhuW5y4ryWQRxz7VZxD4Q.svg)](https://asciinema.org/a/MH4yLhuW5y4ryWQRxz7VZxD4Q)

## Installation

Source `harpoon.kak` in your `kakrc`, or use a plugin manager.

## Usage

Call `harpoon-add-bindings` to add the default keybindings:

- `<user>h`: Harpoon the current file
- `<user>H`: View harpoons list
- `<a-1>`: Navigate to the harpoon at position 1
- `<a-2>`: Navigate to the harpoon at position 2
- ...and so on up through `<a-9>`.

The harpoons list is an interactive buffer listing all of your current
harpoons. You can freely edit or reorder this file, then call `write` to save
it. The new order / contents will be set as your new harpoons. Press `<esc>` to
close the harpoons list.

## Customization

If the default bindings do not work for you, here are the relevant commands to call:

- `harpoon-add`: Harpoon the current file
- `harpoon-nav <index>`: Navigate to the harpoon at `<index>`
- `harpoon-show-list`: View the harpoons list

## Roadmap

- Save line and column information
