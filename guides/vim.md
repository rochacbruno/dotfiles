# VIM CheatSheet

Based on configuration provided in [.config/nvim/init.vim](./.config/nvim/init.vim)


## Glossary

- **L** = Leader Key, mapped to a single space " "
- **C** = Control
- **S** = Shift
- **A** = Left Alt

## Idiom

- **Verbs** are actions such as **v** (visual), **c** (change), **y** (yank/copy),
  **d** (delete), **r** (replace), **p** (paste).
- **Modifiers** specifies regions such as **i** (inside), **a** (around), **t** (till),
  **f** (find).
- **Objects** are parts of the text such as **w** (word), **W** (WORD), **s** (sentence),
  **p** (paragraph), **b** (block), **t** (tag).


## Basic Usage

| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| i | N | Enters Insert Mode |
| v | N | Enters Visual Mode |
| V | N | Enters Visual Line Mode |
| Esc | * | Get Back to Normal mode |
| :w | N | Write file |
| :x | N | Write and exit (ZZ) |
| :qa! | N | Quit not saving all buffers (ZQ) |
| . | N | Repeat last registered action |
| u | N | Undo |
| C-r | N | Redo |


## Movement

| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| gg | N | File Home |
| G | N | File End |
| 5G | N | Go to line 5 |
| :-3 | N | Go to 3 alines above |
| b | N | Move to start of previous word |
| B | N | Move to start previous WORD |
| e | N | Move to end of next word |
| E | N | Move to end of next WORD |
| w | N | Move to start of next word |
| W | N | Move to start of next WORD |
| $ | N | Move to end of line |
| 0 | N | Move to start of line |
| % | N | Go to corresponding bracket |
| * | N | Go to next, prev # match of word |
| fa | N | Go to next letter a (, and ; navigates) |
| ta | N | Go to before of next letter a (, and ; navigates) |

> Tip: WORD is a word + ponctuation, F and T do backwards.


## Search


| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| * | N | Search the cursor word |
| s/word/other | N | replaces 1st word in current line |
| s/word/other/g | N | replaces all word in current line |
| %s/word/other/g | N | replaces all word in whole file |
| 10,15s/word/other/g | N | replaces word on lines 10-15 |


## Text Manipulation


| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| ggVG | N | Select all text |
| Yp | N | Duplicate Line |
| gcap | N | Comment whole paragraph |
| gcc | N | Comment the whole line |
| cs"' | N | Change surrounding " to ' |
| ds" | N |  Delete surrounding " |
| cst" | N | Change `<foo>` to `"foo"` |
| viwS" | N | Select and Surround with "quote" |
| ysiw | N | Add surrounds to a word "foo" |
| I | N | Insert at start of the line |
| a | N | Insert after cursor |
| A | N | Insert at the end of the line |
| o | N | New line above |
| O | N | New line below |
| r | N | Replace Char |
| x | N |  Delete current char |
| cc | N | Replace line |
| cw | N | Replace to the end of workd |
| ciw | N | Replace the inner word |
| c$ | N | Replace to the end of word |
| ~ | N | Change char case, repeat with . |
| C-A | N | Increment a number |
| dd | N | Delete line |
| diw | N | Delete inside word |
| cis | N | Change inside sentence |
| ci" | N | Change inside quote |
| c/foo | N | Change until foo |
| ctX | N | Change until T |
| A-= | V | Assign value to a name it, move it then ESC. |


## Text Selection and Copying


| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| yy | N, V | Copy a line or selection |
| 5yy | N, V | Copy 5 lines |
| yw | N |  Copy a word |
| ye | N | Copy until the end of word |
| y$ | N | Copy to the end of the line |
| y2/foo | N | Copy until second foo |
| p | N |  Paste after cursor |
| 4p | N |  Paste after cursor 4 times |
| P | N |  Paste before cursor |
| dd | N | Cut line |
| 3dd | N | Cut 3 lines |
| dw | N | Cut word |
| D | N | Delete to the end of line |
| d$ | N | Delete to the end of line |
| dt" | N | Delete to the next " |
| /s | N | Search |
| vap | N | Visual Select Around Paragraph |

## Visual mode

| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| vi" | V | Select everything inner " |
| va" | V | Select everything including " |
| vi) | V | Select everything inner () " |
| v2i) | V | Select evertyhing inner 2 outer ) |

### Multi line edit


| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| 0 C-q select I-- Esc | N | Enters block mode, selects all first columns, add -- |
| C-q select $ A-- Esc | N | Adds -- to the end of all lines |
| J | V | Join selected lines |
| gJ | V | Join selected block in a one liner |
| gS | V | Split selected line in 2 |
| < > | V | Indent |
| = | V | auto indent |


## Files

| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| L-pw | N | Rg search the current word |
| L-ps | N |Rg content search in current folder files |
| L-pf | N | Open/Preview files in current folder |
| L-b | N | Open buffers preview |
| L-f | N | Another File NAvigator |
| C-P | N | Git Giles |
| F3 | N | NERDTree |
| F4 | N | TagBar |
| L-e | N | Opens a file in the current dir |
| L-e | N | Opens a file n the current dir |
| L-te | N | Opens a file in the current dir on a tab |
| L-prw | N | CocSearch current word on all buffers |
| L-ghw | N | Get Help for Word |


## Windows

| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| L-hjkl | N | Switch windows (C-W-hjkl) |
| L-z, L-x | N | Next/Previous Buffer |
| L-c | N | Close current buffer |
| L-q | N | Close current split (C-w-c) |
| L-o | N | Open new file in vertical (vnew) |
| L-] | N | New Horizontal Split |
| L-\ | N | New vertical split |
| C-w-n | N | New file on horizontal split |
| C-w-s | N | Split horizontal current file |
| C-w-v | N | Split vertically current file |
| C-w-w | N | Next Split |
| C-w-p | N | Prev Split |
| C-w-arrows | N | Move to split |
| C-w-hjkl | N | Jump to Split |
| C-w-g hjkl | N | Move windows |
| C-w-T | N | Move split to a tab (why?) |
| C-w->,< | N | Increase/DEcrease width |
| C-w-+,- | N | Increase/DEcrease height |
| C-w-q | N | Close Split and file |
| C-w-o | N |  Keep only current split |
| C-w-`|` | N | Maximize Vertical Split |
| C-w-_ | N | Maximize Horizontal Split |
| C-w-= | N | Restore split sizes |
| C-w-m | N | Maximize toggle current split |

## Code Analysis

| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| L-gd | N | Go to definition |
| L-gy | N | Go to type definition |
| L-gi | N | Go to implementations |
| L-gr | N | Go to references |
| L-cr | N | Coc Restart |


## Utilities


| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| L-u | N |  Undo tree |
| L-y | N |  Undo History |
| L-, | N |  Clear highlivght (noh) |
| L-. | N |  Set working dir |
| L-g | N | Current line on git |
| L-gm | N | Show git message for current line |

## More

| Key         | Mode | Description |
| ----------- | ---- | ----------- |
| 100ifoo [ESC] | N | Will write "foo" 100 times |
| 100ifoo[ENTER][ESC] | N | Will write "foo" in 100 lines |
| 3. | N | Will write "foo" 3 times after above command |
| L-id | N |  Generates an UUID |


## Plugins

- `:DB` - manage databases
- `:DBUI` - manage databases in a buffer ui
- `:Clap` - Preview and search and preview colorscheme
- `:Leaders` - Show all leader mappings
- `:Bufferize` - Run a command and send output to a buffer
- `:Dispatch` - Run command in BG
- `:Black` - Format python code

## Tricks

### Macro

qa record your actions in the register a.
Then @a will replay the macro saved into the register a
as if you typed it. @@ is a shortcut to replay the last executed macro.

#### Example

On a line containing only the number 1, type this:

- `qaYp<C-a>q` →
  - qa start recording.
  - Yp duplicate this line.
  - `<C-a>` increment the number.
  - q stop recording.
- @a → write 2 under the 1
- @@ → write 3 under the 2
- Now do 100@@ will create a list of increasing numbers until 103.

## References

- https://vim.rtorr.com/



> Nvim with File Navigator, TagBar and Python Editing + Linter

![vim shot](./vim_shot.png)

> Nvim with Python AutoComplete

![vim shot](./vim_shot2.png)

> Nvim with Fuzzy Finder to open files (using ripgrep)

![vim shot](./vim_shot3.png)
