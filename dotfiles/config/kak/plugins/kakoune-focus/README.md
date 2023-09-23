# kakoune-focus
`kakoune-focus` is a plugin to let you work on multiple selections more efficiently by hiding lines that are far from your selections using Kakoune's `replace-ranges` highlighter (`:doc highlighters specs-highlighters`).

> **Note**
> This plugin requires [Kakoune release 2022.10.31](https://github.com/mawww/kakoune/releases/tag/v2022.10.31) or a revision after the breaking change at [mawww/kakoune@ef8a11b](https://github.com/mawww/kakoune/commit/ef8a11b3dbefb8a1222974a8c34e15fa006d56e0).

![demo](https://caksoylar.github.io/kakoune-focus/focus.gif)

## Installation
You can copy `focus.kak` to your `autoload` folder, e.g. into `~/.config/kak/autoload`.

If you are using [plug.kak](https://github.com/andreyorst/plug.kak):
```kak
plug "caksoylar/kakoune-focus" config %{
     # configuration here
}
```

## Usage
Once you have the (ideally multiple) selections you want to focus on, use `focus-selections` to hide the surrounding lines. You can use `focus-clear` to disable this or use `focus-toggle` to toggle it on and off.

I recommend assigning a mapping for easy access, for example `,<space>` to toggle:
```kak
map global user <space> ': focus-toggle<ret>' -docstring "toggle selections focus"
```

You can also extend the focus area to include your current selections using `focus-extend`, which can be called multiple times. Using this feature you can even create a live-updating focus area that extends itself to lines you have visited. For example you can define and use commands like below:
```kak
define-command focus-live-enable %{
    focus-selections
    hook -group focus window NormalIdle .* %{ focus-extend }
}
define-command focus-live-disable %{
    remove-hooks window focus
    focus-clear
}
```

## Configuration
There are a couple of options you can configure:
- `focus_separator (str)`: What string to use as the separator to replace hidden lines, can use markup strings `:doc faces markup-strings`
- `focus_context_lines (int)`: How many lines of context to preserve above and below selections (default: 1)

## Caveats
Due to [a Kakoune shortcoming](https://github.com/mawww/kakoune/issues/3644) with the `replace-ranges` highlighter, some lines can be visually cut off from the bottom after focusing. This seems to be an issue especially when long spans of lines are hidden and soft line wrapping is enabled with the `wrap` highlighter.

## License
MIT
