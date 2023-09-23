# wezterm.kak
Provides basic [WezTerm](https://github.com/wez/wezterm) integration for Kakoune. Modeled after Kakoune's default windowing modules.

# THIS REPO IS UNMAINTAINED
I have started using a different editor for a while and I have had very little desire to develop or maintain this plugin ever since. I would like to thank everyone that used this and I am very glad that people other than I have found my plugin to be useful.

# Installation
With [plug.kak](https://github.com/andreyorst/plug.kak), add the following to your kakrc:

    plug Anomalocaridid/wezterm.kak %{
        wezterm-integration-enable
    }

Otherwise, add it to your autoload folder or source it manually, making sure to add `wezterm-integration-enable` to your kakrc.

# Features
Currently, only splitting the window into panes, and opening a command in a new tab or window are supported. I was unable to find a way to use WezTerm's command-line interface to focus a given client or send text to a REPL. Since WezTerm is fairly new, that functionality may not even be currently supported yet.

## Commands
* `wezterm-integration-enable` - sets the other commands' aliases when running on WezTerm
* `wezterm-integration-disable` - removes WezTerm integration hooks
* `wezterm-terminal-vertical` - splits the current window vertically and runs a given program; aliased to `terminal` by default
* `wezterm-terminal-horizontal` - splits the current window horizontally and runs a given program
* `wezterm-terminal-window` - opens a new instance of WezTerm and runs the given command in it; aliased to `terminal-window`
* `wezterm-terminal-tab` - opens a new tab and runs the given program in it; aliased to `terminal-tab`

## Options
* `wezterm_terminal_default` - sets the `terminal` alias's default value; set to `wezterm-terminal-vertical` by default

## User Mode
* `wezterm` - used to set the terminal alias on the fly
	* `v` - sets it to `wezterm-terminal-vertical`
	* `h` - sets it to `wezterm-terminal-horizontal`
	* `w` - sets it to `wezterm-terminal-window`
	* `t` - sets it to `wezterm-terminal-tab`

# TODO
* Add the command `wezterm-focus` that focuses a given client and alias it to `focus` in `wezterm-integration-enable`
* Add REPL functionality.
