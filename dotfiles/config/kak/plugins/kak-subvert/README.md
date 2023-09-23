[![crates.io image](https://img.shields.io/crates/v/kak-subvert.svg)](https://crates.io/crates/kak-subvert)

# kak-subvert

Allow converting selection to various casings.

For instance, `foo_bar` to `FooBar`

Known casings:

```
camel               fooBar
http                Foo-Bar
kebab               foo-bar
pascal              FooBar
sentence            Foo bar
snake               foo_bar
screaming           FOO_BAR
title               Foo Bar
train               Foo-Bar
ugly                Foo_Bar
```

## Installation

```
$ cargo install kak-subvert
```

This should add a `kak-subvert` command to your $PATH.

Then you should add something like [subvert.kak](./subvert.kak) in your Kakoune configuration.
