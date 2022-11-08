# Dotfiles

## Help

[Micro editor](guides/micro.md)
[i3 wm](guides/i3.md)

## Requirements

Managed by [dotdrop](https://github.com/deadc0de6/dotdrop)

## Usage

Add a new file to be tracked by dotdrop

```bash
./dotdrop.sh import filepath
```

Update dotdrop repo after changes in the host system

```bash
./update.sh

# or ./dotdrop.sh update -f
# ./update.sh automates secrets hiding and some extra files
```

Compare repo with host system (or new system before install)
```bash
./dotdrop.sh compare
```

Install on a new host

```bash
./dotdrop install
```
