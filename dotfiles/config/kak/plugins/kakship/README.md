# kakship and kakship.kak

`kakship` is just a thin wrapper around [starship](https://starship.rs) to format the status line of
[kakoune](https://kakoune.org/) and is meant to be used with the included kakoune script `kakship.kak`.

![kakship prompt](kakship.png?raw=true "Kakship prompt")

## Operating mode

`kakship`

- overrides override the default config file path with `$kak_config/starship.toml`,
- sets the STARSHIP_SHELL to be `sh`
- forwards the given arguments to `starship`,
- transforms ansi-codes to kakoune face definitions when called with `prompt` argument.

It uses a forked [yew-ansi](https://github.com/eburghar/yew-ansi.git) crate for parsing the ansi-codes to which I just
added support for `reversed` and `dimmed` ansi-codes that can be used in `starship` styles definitions.

The kakoune script call `kakship` in normal mode when idle for all buffers whose names don't start and end with
`*`. As `starship` is really fast and format a prompt in ms, the script doesn't need to be clever about when
refreshing the status bar.

## Installation

### Prerequisites

- [starship](https://starship.rs) must be installed,
- you should probably use a [nerd font](https://www.nerdfonts.com) for your terminal

### Manual

1. Compile `kakship` with cargo and install it somewhere in your $PATH (for example `~/.local/bin`)

```sh
cargo install --force --path . --root ~/.local
```

2. Copy/modify the provided [starship.toml](starship.toml) to your `$kak_config` directory (usually `~/.config/kak/`)


3. Put the `kakship.kak` script in your autoload path and add something like this to your kakrc

```
hook global ModuleLoaded kakship .* %{
	kakship-enable
}
```

### With a plugin manager

with [plug.kak](https://github.com/andreyorst/plug.kak)

```
plug "eburghar/kakship" do %{
	cargo install --force --path . --root ~/.local
	[ ! -e $kak_config/starship.toml ] && cp starship.toml $kak_config/
} config %{
	kakship-enable
}
```

## Writing custom segments

To write new segments, you can use the [custom-commands](https://starship.rs/config/#custom-commands) module of
starship. Define a new section with a dot notation `[custom.mymodule]`, and insert a variable with the same name
in the topmost format definition (`format=...${custom.mymodule}..`)

In case you just need string substitutions (like `custom.kakmode` bellow), you can avoid calling a shell to evaluate
the `when` condition by setting the `shell` variable to `['true']` and the `when` variable to `''`. In case no
`$output` variable appears in the format definition of the segment, no shell is called, making your segment faster
to evaluate.

In case you really need to call an external command, you have 3 choices:

1. setup `shell`, `command` and `when` and let starship do the evaluation

2. use kakoune expansion blocks (`sh`, `opt`, `val`, `reg`, `file`) inside the format and let kakoune do the
evaluation. Note than only curly brace is supported as the quoting char.

3. a mix of kakoune and starship evaluations

With kakoune expansion the modeline will change as soon as the variable, register, option, value, used in the
expression changes and in the case of `%sh` kakoune will rebuild the modeline every second or so when in normal
mode. In other words, the modline will change without ever needing to call kakship. This leads for example to
a custom time segment definition (`custom.kaktime` below) which will show seconds even if the editor is idle,
contrary to the starship [time module](https://starship.rs/config/#time) which changes only during pause.

As for the 3rd option, you can use environment variables (starship evaluation) for telling starship when to
display a segment, and use a kakoune expansion in the format to let kakoune do the update as soon as possible (see
`custom.kaklsp_err` bellow).

If you need access to kakoune variables in your segments, don't forget to add its name prefixed by `kak_opt_`
as a comment in `kakship.kak` file, otherwise it will not be exported to starship process.

```bash
		# trigger var export: kak_buffile, kak_session, kak_client, kak_config, kak_cursor_line, kak_buf_line_count
		#                     kak_opt_lsp_diagnostic_error_count, kak_opt_lsp_diagnostic_warning_count,
		#                     kak_opt_lsp_diagnostic_hint_count
```

## Kakoune segments

Here are some common custom segments for kakoune. I'll be happy to maintain a catalog if you send me a PR.

```toml
[custom.kakfile]
description = 'The current Kakoune buffername'
format = '[/$output ]($style)[]($style inverted) '
style = 'bold bg:blue fg:black'
command = 'echo -n ${kak_buffile##*/}'
when = 'true'
shell = ['sh']
disabled = false
```

```toml
[custom.kaksession]
description = 'The current Kakoune session'
format = '[]($style)[  %val{client}:%val{session} ]($style)[]($style inverted)'
style = 'bg:yellow fg:black'
when = ''
shell = ['true']
disabled = false
```

```toml
[custom.kakcursor]
description = 'The current Kakoune cursor position'
format = '[%val{cursor_line}:%val{cursor_char_column}]($style)'
style = 'fg:white'
when = ''
shell = ['true']
disabled = false
```

```toml
[custom.kakmode]
description = 'The current Kakoune mode'
format = ' {{mode_info}}'
when = ''
shell = ['true']
disabled = false
```

```toml
[custom.kakcontext]
description = 'The current Kakoune context'
format = ' {{context_info}}'
when = ''
shell = ['true']
disabled = false
```

```toml
[custom.kakfiletype]
description = 'The current buffer filetype'
format = '\[%opt{filetype}\] '
when = ''
shell = ['true']
disabled = false
```

```toml
[custom.kakposition]
description = 'Relative position of the cursor inside the buffer'
format = '[  $output]($style)'
style = 'bright-white'
command = 'echo -n $(($kak_cursor_line * 100 / $kak_buf_line_count))%'
when = '[ -n "$kak_cursor_line" ]'
shell = ['sh']
disabled = false
```

```toml
[custom.kaktime]
description = "Alternate time segment using kakoune evaluation"
format = "[]($style)[  %sh{date +%T} ]($style)"
style = "fg:black bg:bright-green"
when = ''
shell = ['true']
disabled = false
```

```toml
[custom.kaklsp_err]
description = "Show errors number from kak-lsp if any"
format = "[  %opt{lsp_diagnostic_error_count}]($style)"
style = "red bold"
when = '[ -n "$kak_opt_lsp_diagnostic_error_count" -a "$kak_opt_lsp_diagnostic_error_count" -ne 0 ]'
shell = ['sh']
disabled = false
```

```toml
[custom.kaklsp_warn]
description = "Show warnings number from kak-lsp if any"
format = "[  %opt{lsp_diagnostic_warning_count}]($style)"
style = "yellow bold"
when = '[ -n "$kak_opt_lsp_diagnostic_warning_count" -a "$kak_opt_lsp_diagnostic_warning_count" -ne 0 ]'
shell = ['sh']
disabled = false
```

```toml
[custom.kaklsp_hint]
description = "Show hints number from kak-lsp if any"
format = "[ ﯦ %opt{lsp_diagnostic_hint_count}]($style)"
style = "yellow bold"
when = '[ -n "$kak_opt_lsp_diagnostic_hint_count" -a "$kak_opt_lsp_diagnostic_hint_count" -ne 0 ]'
shell = ['sh']
disabled = false
```

```toml
[custom.kaklsp_code_actions]
description = "Show lsp code actions if any"
format = "[ %opt{lsp_modeline_code_actions} ]($style)"
style = "yellow bold"
when = '[ -n "$kak_opt_lsp_modeline_code_actions" ]'
shell = ['sh']
disabled = true
```

```toml
[custom.kaklsp_progress]
description = "Show activity of kak-lsp if any"
format = "[ ]($style)"
style = "bright-white bold"
when = '[ -n "$kak_opt_lsp_modeline_progress" ]'
shell = ['sh']
disabled = false
```

## Tips

To check if your modeline is not overloaded.

```sh
kak_config="~/.config/kak" kakship timings
```

To check the settings with all modules default values

```sh
kak_config="~/.config/kak" kakship print-config
```

To debug the prompt as set under kakoune

```sh
kak_config="~/.config/kak" kakship prompt
```

## References

[powerline.kak](https://github.com/andreyorst/powerline.kak) is another excellent kakoune plugin from Andrey Listopadov
devoted to modeline which relies merely on kakscript, has themes and even has an API for defining new plugins.
