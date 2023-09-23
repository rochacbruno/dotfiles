declare-option -hidden -docstring 'Path to k9s0ke-shlib' str k9s0ke_shlib_dir %sh{ echo "${kak_source%/*}"/ }

provide-module -override k9s0ke-shlib %{
declare-option -hidden -docstring 'k9s0ke-lib code (eval in %sh{})' str k9s0ke_shlib_code ''

define-command k9s0ke-shlib-reload %{
set global k9s0ke_shlib_code ''
k9s0ke-file2opt global k9s0ke_shlib_code "%opt{k9s0ke_shlib_dir}/k9s0ke-shlib.sh"
k9s0ke-file2opt global k9s0ke_shlib_code "%opt{k9s0ke_shlib_dir}/k9s0ke-kak-helpers.sh"
} -docstring %{Reload k9s0ke_shlib library code}

def k9s0ke-file2reg -params 2 %{
  eval reg '%arg{1}' "%%file<%arg{2}>"
} -docstring %{Load file contents into a register
Arguments: register path
Does not shell out. Filename must balance or avoid '<' / '>'.
Throws if file unreadable.
} -override
def k9s0ke-file2reg0 -params 3 %{
  try %{
    k9s0ke-file2reg %arg{1} %arg{2}
  } catch %{
    reg %arg{1} %arg{3}
  }
} -docstring %{Load file contents (or alternative value) into a register
Arguments: register path value-on-fail
Does not shell out. Filename must balance or avoid '<' / '>'.
} -override

def k9s0ke-file2opt -params 3 %{
eval set -add '%arg{1}' '%arg{2}' "%%file<%arg{3}>"
} -docstring %{Append file contents to an option
Arguments: scope option-name path
Does not shell out. Filename must balance or avoid '<' / '>'.
Throws if file unreadable.
} -override

def k9s0ke-eval-a1 -params 2.. %{
  # top-level implicit eval passes a '%arg{@}' string + arg2 to eval
  # explicit eval calls %arg{@} list + eval'd arg2
  eval -- '%arg{@}' "%arg{2}"
} -docstring %{Eval the 1st argument of a command; append its value to the arg list
Arguments: command to-eval-arg [regular-arg...]
} -override

define-command def-sh-with-prelude-cmd -params 2.. %{
# %arg{1} is the script and gets pasted ad-literam inside %sh
# but it also becomes $1, so we must shift it away
def %arg{1} -params 1.. %sh{
cat <<EOF
eval -- $3 -- "%%sh{
: '{{{{{{{{{{{{{{{{{{{{'
%opt{$2}
shift
%arg{1}
: '}}}}}}}}}}}}}}}}}}}}'
}"
EOF
} -docstring "evaluate sh code with prelude from option %arg{2}
Passes any shell output to kakoune '%arg{3} --'.
Arguments: shell-code [shell-$1 [shell-$2...]]
" -override -hidden
} -docstring %{define a sh-with-prelude command
Arguments: command-name prelude-option { nop | eval | echo -debug | whatever }
} -override

# nice, faster (no eval "$prelude"); but complicates debugging / profiling:
#def-sh-with-prelude-cmd k9s0ke-shlib-eval k9s0ke_shlib_code eval
define-command k9s0ke-shlib-eval -params 1.. %{
  # v------------ paste %1 into %sh{}; %1 must balance {}s (but ""s, % ok)
  #       v------ what to do with %sh{} output (could be echo, nop etc)
  #               v--- inside "": all inner "" must be doubled; %%XX escapes %XX
  eval -- eval -- "%%sh{
    eval ""$kak_opt_k9s0ke_shlib_code""; shift
: '{{{{{{{{{{{{{{{{{{{{'
%arg{1}
: '}}}}}}}}}}}}}}}}}}}}'
  }"
  # ^------------ shell prelude: load shlib code, shift pasted %arg{1}
} -docstring %{evaluate sh code with a k9s0ke_shlib prelude
Passes any shell output to kakoune 'eval --'.
Arguments: shell-code [shell-$1 [shell-$2...]]
} -override

k9s0ke-shlib-reload
}
