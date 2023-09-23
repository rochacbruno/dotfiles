# kakoune-sudo-write

[kakoune](http://kakoune.org) plugin to save files that you do not have write permissions for. Uses `sudo` and preserves file ownership and read-write attributes.

## Setup

Add `sudo-write.kak` to your autoload dir: `~/.config/kak/autoload/`, or source it manually.

## Usage

Call the `sudo-write` command. If your password has not been cached by `sudo`, you will be prompted to input it. Upon success, the buffer is written to the file.

**Warning**: while the input is hidden, the password is still passed through stdin to `sudo`. Do not use this plugin if you are not comfortable with this idea.

## License

Unlicense
