# Kakoune Toggler

A la [toggler-vscode](https://github.com/HiDeoo/toggler-vscode),
this plugin allows you to toggle words.

## Features

- Toggle between words!
- Toggle between multiple words!
- Toggle with multiple cursors!
- Respects casing in (probably) most languages!
- Supports TOML config, the **best** config!

## Requirements

Just Rust.

### Wait, wasn't this in C++?

Yeah, but I wanted something concrete to make in Rust, and in the process,
I made it safer, less hardcoded, fixed a massive bug, and at least 50% faster.
So I think it's a worthy tradeoff.

## Installation

It is _highly_ recommended to use [plug.kak](https://github.com/robertmeta/plug.kak).
If so, add this to your kakrc

```sh
plug "abuffseagull/kakoune-toggler" do %{ cargo install --path . }
```

Otherwise, just stick it wherever, and make sure the binary (`kakoune-toggler`) is on your path.

## Configuration

Your togglable words can be configured in a `toggles.toml` file in your kak config directory.

The toggles are in an array of arrays of strings,
under the `toggles` key under a table named by the filetype you would like them to be available under.

Or to better explain it:

```toml
[javascript]
toggles = [
  ["setTimout", "setInterval"],
]

# There's a special global table that will work in every filetype
[global]
toggles = [
  ["true", "false"],
  ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"],
]

# You can also extend filetypes
[html]
extends = ["javascript", "css"]
toggles = [
  ["div", "span"],
]
```

Recommended config for plugin:

```
map global user t ': toggle-word<ret>' -docstring 'toggle word'
map global user T ': toggle-WORD<ret>' -docstring 'toggle WORD'
```

The only difference between the two commands is whether it uses `<a-i>w` or `<a-i><a-w>` for selecting the word you're on.

#### Issues and Pull Requests welcome!
