# k9s0ke-shlib

## _Shell function library to avoid calling external commands_

This library provides several functions that can be used in scripts ([`Kakoune`](https://github.com/mawww/kakoune/) plugins in particular). It is currently part of the [`mru-files.kak` project](https://gitlab.com/kstr0k/mru-files.kak), which serves as sample usage.

## Highlights

- [Kakoune usage](#kakoune-usage)
- [Kakoune commands](#kakoune-commands)
- [Shell functions](#shell-functions)
- [Testing](#testing)
- [License & copyright](#copyright)

## Kakoune usage

1. The [`rc/`](rc) folder needs to be somewhere in autoload (possibly symlinked); if you've installed `mru-files.kak`, it already is
1. You must `require-module k9s0ke-shlib`
1. Replace `%sh` code blocks with `k9s0ke-shlib-eval %{ # shell code } [$1-arg $2-arg...]`. Now your code has access to all [shell functions](#shell-functions) defined in the library, and you can also explicitly control shell parameters `$1`, `$2` etc. Whatever the shell code outputs will be eval'd by Kakoune (see [Kakoune commands](#kakoune-commands)).

As an alternative to the last step, inside kakoune `%sh{}` blocks, put this at the top: `eval "$kak_opt_k9s0ke_shlib_code"`. You will no longer be able to control shell parameters (`$n` remains `%arg{n}`).

## Kakoune commands

- `k9s0ke-shlib-eval code [shell-args]`: call the shell with the specified code and arguments, and all `shlib` [shell functions](#shell-functions) defined in a prelude; then evaluate the shell output using Kakoune '`eval --` (no switches). You may want to "`exec >/dev/null`" / "`exec 1>&2`" as the first thing in your shell code to ignore shell output / send it to the debug buffer. The shell output can of course be another `eval` command, perhaps with switches, but this can get tricky &mdash; use `def-sh-with...` below.
- `def-sh-with-prelude-cmd NAME option-name kakoune-action`: define a new command "NAME" similar to `k9s0ke-shlib-eval`; you can choose the option which stores the prelude, and what to do with shell output (`nop`, `eval -draft -no-hooks`, `echo -debug` etc). All shell code (both prelude and argument) must balance the **total number of braces** (in whatever order), or you will need to add work-arounds.
- `k9s0ke-file2reg scope register path`: load a file into a register; performed **without invoking the shell**
- `k9s0ke-file2opt scope option-name path`: *append* file contents to an option (you may want to clear it first); also performed without shell help

## Shell functions

Some functions operate on stdin and can be called inside pipes (or you can `$(capture)`, or better `__slurp`, their output). Wherever possible, there are specialized versions with much less overhead (pipes, forks); they can, however, exhibit different complexity for large inputs (e.g. quadratic behavior). Check the source for availability:
- `__str_...`: operate on a string instead of stdin
- `..._r4`: set a global `_R4_...` "result-for" variable instead of printing to `stdout`; if multiple results: `_R4_1...`, `_R4_2...`
- `..._ref`: set one / several output variable named in additional initial parameters

### Convenience / correctness

- `__readline_[ref|r4]`: like `IFS= read`. It has two results (in `_R4_[1|2]readline`, or the vars supplied to the `_ref` version): the line read in, and an `EOF` flag (`true` / `false`; can be tested with `if "$eof"`, see [shell boolean](https://gitlab.com/kstr0k/bashaaparse#bash-booleans)). The line includes a final `\n`, unless `EOF` reached.
- `__slurp var < ...`: stores its `stdin` in `var`. Like `var=$(cat ...)` but without trimming final newlines
- `__slurp_out_rc outvar rcvar cmd... <...`: stores a command's output in `outvar` and its exit status in `rcvar` (if either is `''`, ignored). Like `var=$(cmd...)` but without trimming final newlines. `cmd` can also be a shell function or builtin (e.g. `eval`), but it will be forced to run with `set +e`; also, if it calls `exit`, it will corrupt any final newlines and generate an empty `rcvar`.
- `__herestring str cmd...`: like `cmd <<<str` in bash (`str` gets a final newline, in particular), but `cmd` executes in the **same process** (e.g. `eval` can set variables). Can be combined with `__slurp_cmd`.
- `__str_join_ch`: join strings with a *single* separator character, or `''`
- `__str_subst text find replace`: replaces fixed strings (not regex)
- `__str_strip_[lead|trail] str chars`: strip leading / trailing characters from a character set `[$chars]`. Use it with `chars = '0-3xy'`, named POSIX classes (`chars = '[:space:]'`, `chars = '[:alnum:]'` etc), or any combination thereof. Negate the set by prepending an initial "`!`" (the POSIX shell pattern convention &mdash; unlike the usual `[^negated]`).
- `__str_strip_trail_slash`: like above, but produce `/` instead of an empty string
- `__str_repeat n str`: repeats `str`
- `__fdecl[_eval] name body`: outputs code to declare a shell function (pass to eval later, or call `..._eval` directly)

### echo and printf

The standard shell echo is well-known to have unportable, hard-to-bypass behaviors switches / escape sequences. `printf` is a better choice, but can have surprising behavior in the zero-argument case; it also can't fully emulate `echo arg...` (as "`printf '%s ' "$@"`" prints an extra final space, even with zero arguments). 

- `__echo`: equivalent to `IFS=' '; printf '%s\n "$*"'`, saving and restoring `IFS`.
- `__echon`: like `echo -n` (no newline), with the notes above.
- `__echo[n]_lines`: like `printf '%s[\n]' ...`, without problems in the zero-argument case. For these functions `\n` is a terminator (not a separator as in `__echo*`).

### Emulating standard utilities

#### Paths and files

- `__abspath1 path`: prepend `$PWD` if '`path`' is not absolute
- `__realpath1 path`: resolve a logical path to a physical path with no symbolic links
- `__dirandbasename`: strip final slashes, then separate the last path component (after final `/`). Does not look at the filesystem, does not special-case a final `.` or `..` etc.
- `__str_path_canon_end`: URL-like canonicalization (stripping extra `..` / `.` components, multiple slashes). Does not look at the file system, so this is *not* a subsitute for `realpath` (e.g. in reality it's possible that `/dir1/symlinked2/.. != /dir`)
- `__mkdirp`: like `mkdir -p`, except `mkdir -p new1/../new2` creates both `new1` and `new2`). Tests for existence first, avoiding external calls.
- `__mkdirp_dirname`: like `mkdir -p "$(dirname "$1")` (uses `__dirandbasename`).

#### Filters

- `__wcl`: `wc -l`
- `__head n` / `__tail n` (note that `__tail 0` will consume all input even if producing no output &mdash; this is less surprising than the `GNU` tail behavior)
- `__tail_plus n`: `tail +n` (lines starting at `n`, 1-based numbering)
- `__tac`: like `tac` (reverse lines in input)
- `__grepF v x1 x2 str`: like `grep -F [-v] [-x] str`. `v` (to invert the search) is `true` / `false`. `-x` (match entire line) is emulated with `x=''`, otherwise use `x=*`. The choices for beginning / end anchoring (`x1 / x2`) can be distinct.
- `__grepSHPAT v x1 x2 shpat`: like `grep [-v] [-x]`, but uses shell patterns (`*`, `?`). Same usage as above for `-v` and `-x`
- `__fieldparse_eval shcode`: this might help reduce calls to `awk`, `cut` and the like. It splits each line on whitespace (including trimming leading / final blanks) and calls `shcode` as a function body with the fields as parameters `$1`, `$2` etc. For example, the following swaps fields 2 and 3 (completely collapsing whitespace):
```
k9s0ke-shlib-eval %{
  printf '%s\n' ' a b c ' 'x   y z' |
    __fieldparse_eval 'printf "%s %s\n" "$3" "$2"'
}
```

### Quoters

These functions output to stdout; there are also `__str_s?l_quote[_one]_r4` versions which set a global `_R4_s?l_quote[_one]` output variable for ultimate speed / flexibility.

- `__str_sql_quote str1 str2...`: per the SQL (and Kakoune) convention, escapes single-quotes in its arguments by doubling them, then surrounds each escaped string with single quotes, then concatenates the quoted arguments. The result is a string that can be passed safely (unquoted) to SQL (or Kakoune, e.g. via `kak -p`) as input.
- `__str_sql_quote_one prefix suffix str...`: outputs the prefix (e.g. ' '), concatenates all remaining arguments (`"$*"`) and quotes the concatenation as a single value
- `__sql_quote` (without `str_` prefix): reads from stdin &mdash; same as `__str_sql_quote "$*" "$(cat)"`; convenient if sticking to pipelines
- `...shl_quote...` versions: same as `*sql*` but with shell quoting conventions (replace single quotes with "'\\''", surround with `''`s)

See the [kak %sh prelude proposal](https://github.com/mawww/kakoune/issues/3340) on github, and the [`kak_quoter_benchmark` snippet](https://gitlab.com/kstr0k/mru-files.kak/snippets/2137556.git) for the origin of these functions / performance considerations.

## Testing

The library can be tested using [t3st](https://gitlab.com/kstr0k/t3st) &mdash; see the test branch:
```
git worktree add /tmp/mru-files-test test
cd /tmp/mru-files-test
prove -vr t/k9s0ke-shlib  # or ./run
```

## Implementation

Upon initialization, the module loads the library code from [`k9s0ke-shlib.sh`](rc/k9s0ke-shlib.sh) and [`k9s0ke-kak-helpers.sh`](rc/k9s0ke-kak-helpers.sh) into the hidden option `k9s0ke_shlib_code`. `k9s0ke-shlib-eval` pastes that code directly into a dynamically-created `%sh` block.

In development, the library code can be reloaded with `k9s0ke-shlib-reload`.


## Copyright

`Alin Mr. <almr.oss@outlook.com>` / MIT license
