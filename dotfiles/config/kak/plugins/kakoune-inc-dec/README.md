Increment and Decrement for Kakoune
===================================

Vim has a nifty feature where
you can increment and decrement the number under the cursor
by hitting `<c-a>` and `<c-x>` (respectively).
Kakoune doesn't implement such a feature,
so this script adds it back in.

Features
========

This script allows you to increment and decrement:

  - Hexadecimal numbers, upper-case or lower-case, prefixed with `0x`:

        0x12ab
        0x0089EF

  - Octal numbers, prefixed with `0o`:

        0o644
        0o00755

  - Decimal numbers, with optional sign and leading zeroes.

        1234
        -009876

Installation
============

 1. Make the directory `~/.config/kak/autoload/`
    if it doesn't already exist.

        mkdir -p ~/.config/kak/autoload

 2. If it didn't already exist,
    create a symlink inside that directory
    pointing to Kakoune's default autoload directory
    so it Kakoune will still be able to find
    its default configuration.
    You can find Kakoune's runtime autoload directory
    by typing

        :echo %val{runtime}/autoload

    inside Kakoune.
 3. Put a copy of `inc-dec.kak` inside
    the new autoload directory,
    such as by checking out this git repository:

        cd ~/.config/kak/autoload/
        git clone https://gitlab.com/Screwtapello/kakoune-inc-dec.git

TODO
====

  - It'd be lovely to support
    date incrementing and decrementing,
    if there were some portable tool to do date arithmetic.

        sqlite3 :memory: "select date('2018-08-15', '+1 day')"

  - I'm not sure it works
    if the selection contains multiple supported syntaxes
    like decimal and octal integers.
