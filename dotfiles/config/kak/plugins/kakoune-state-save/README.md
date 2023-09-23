State-saving for Kakoune
========================

When using a light-weight editor like Kakoune,
it's a common workflow to
edit a file,
make a change,
save and quit,
observe the result,
then edit the file again.
Unfortunately,
Kakoune doesn't remember
any state from the last time you edited a file,
so it can be tedious finding your place again.

This plugin makes Kakoune
record what text is selected
as you move through a file,
and restores those selections
the next time you load that file.
It also allows you to save and restore
the contents of registers
like the command history and search history.

Features
========

  - Automatically records the current selections in a `NormalIdle` hook
  - Allows you to automatically save and restore command history,
    search history and other registers.
  - Does not record selections if there are unsaved changes,
    so you don't wind up with a mismatch between
    the saved selections and buffer content.
  - Does not record the state of scratch buffers,
    so you don't wind up with useless state files.
  - Writes the recorded selections to disk when Kakoune exits.
  - Reads them back in when Kakoune opens a file.
  - Can be configured to ignore files matching a glob pattern.

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
 3. Put a copy of `state-save.kak` inside
    the new autoload directory,
    such as by checking out this git repository:

        cd ~/.config/kak/autoload/
        git clone https://gitlab.com/Screwtapello/kakoune-state-save.git

 4. If you want to save and restore command history, search history,
    or other registers, see the "Commands" and "Usage" sections below.

Configuration
=============

The following Kakoune options are available:

`state_save_path`
-----------------

**Type:** `str`

**Default:** `$XDG_DATA_HOME/kak/state-save/`,
or `$HOME/.local/share/kak/state-save/`
if `$XDG_DATA_HOME` is not set.

Controls where buffer state files are stored.

`state_save_exclude_globs`
--------------------------

**Type:** `str-list`

**Default:** `*/COMMIT_EDITMSG`

Any file whose absolute path matches
one of the glob patterns in this list
will be ignored,
and its state will *not* be saved.

This is useful for predictable-named files
whose content often changes,
like the temporary files used for commit messages
or for bash's `fc` command.

Commands
========

Different people use Kakoune's registers in different ways,
so instead of providing a bunch of configuration options,
this plugin provides the following commands
you can call from your own hooks or mappings:

`state-save-reg-save <regname>`
-------------------------------

**regname:** One of the alphabetic register names
from Kakoune's `:doc registers` documentation.

Saves the current contents of the named register
to a file in the `%opt{state_save_path}` directory.

`state-save-reg-load <regname>`
-------------------------------

**regname:** One of the alphabetic register names
from Kakoune's `:doc registers` documentation.

Loads the current contents of the named register
from a file in the `%opt{state_save_path}` directory.

**Note:** Different Kakoune registers behave differently
when loading new values.
For most registers, the new values entirely replace the old values.
For history-like registers
(such as `colon`, the command-history register,
and `slash`, the search-history register)
each new item is appended,
any older duplicates are removed,
and the list is trimmed to 100 total items.

**WARNING:** Properly loading register contents
requires using Kakoune's `evaluate-commands` feature,
which means anyone who can write to files in `%opt{state_save_path}`
can make your Kakoune _**execute arbitrary code**_
when you invoke `state-save-reg-load`.

Usage
=====

After the plugin is installed,
saving and restoring cursor positions works automatically.

To save and restore command-history, search history, and pipe-command history,
add a snippet like this to your `kakrc` file:

    hook global KakBegin .* %{
        state-save-reg-load colon
        state-save-reg-load pipe
        state-save-reg-load slash
    }

    hook global KakEnd .* %{
        state-save-reg-save colon
        state-save-reg-save pipe
        state-save-reg-save slash
    }

You can save and restore other registers too,
see `:doc registers` to learn more.

**WARNING:** `state-save-reg-load` has security implications;
see the warning in the `state-save-reg-load` section above.

Alternatively,
if you might want to sync registers more frequently
(in case Kakoune crashes,
or to keep multiple Kakoune sessions in sync)
you could run those commands from some other hook, like `NormalIdle`,
`FocusOut` or `FocusIn`.
For example,
I keep my yank/paste buffer synchronised between Kakoune sessions like this:

    hook global FocusOut .* %{ state-save-reg-save dquote }
    hook global FocusIn  .* %{ state-save-reg-load dquote }

TODO
====

  - Save and restore undo history for individual buffers
      - Kakoune does not currently expose this information to scripts
