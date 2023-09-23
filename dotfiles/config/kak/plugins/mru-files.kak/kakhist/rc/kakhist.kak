declare-option -hidden -docstring 'Path to kakhist' str kakhist_lib_dir %sh{ echo "${kak_source%/*}"/ }
declare-option -docstring 'Path to history file' str kakhist_file "%val{config}/kakhist.txt"
declare-option -docstring 'Truncate history file after this many entries' int kakhist_max 30
declare-option -docstring 'set -x in sh code' bool kakhist_debug false
declare-option -docstring 'sh code that returns success (0) if command ("$1") should NOT be saved' str kakhist_ignore_sh %{
set -- "$1" "${1%% *}"; set -- "$1" "${2%'!'}"
case "$2" in
  ''|'q'|'quit'|'wq'|'waq'|'write-quit'|'write-all-quit') return 0 ;;
  'e'|'edit'|'w'|'write')
    (set -- ${1#"${1%% *}"}; test -n "$*") ||
      return 0;
    ;;
esac; false
}
# 1=full command, 2=command basename ('' if $1 starts with spaces)
# ignores ': *', quit-related, edit!/write with no args

provide-module kakhist %{

require-module k9s0ke-shlib

def kakhist-save -override %{ eval %sh{
  #: $kak_opt_kakhist_file $kak_opt_kakhist_max $kak_opt_kakhist_ignore_sh $kak_opt_kakhist_debug $kak_quoted_reg_colon $kak_opt_k9s0ke_shlib_code
  . "$kak_opt_kakhist_lib_dir/kakhist.sh" --
  eval set -- "$kak_quoted_reg_colon"
  kakhist_save "$@"
} } -docstring 'Save history to file'
def kakhist-load -override %{
  eval reg colon %sh{
  #: $kak_opt_kakhist_file $kak_opt_kakhist_max $kak_opt_kakhist_ignore_sh $kak_opt_kakhist_debug $kak_quoted_reg_colon $kak_opt_k9s0ke_shlib_code
    . "$kak_opt_kakhist_lib_dir/kakhist.sh" --
    kakhist_load
  }
  eval %sh{ $kak_opt_kakhist_debug && echo 'echo -debug -quoting shell %reg{colon}' || echo nop }
} -docstring 'Load history from file'

def kakhist-buf-save -override -hidden %{ eval -save-regs bc %{
buffer '*kakhist*'
execute-keys -draft 'gj<a-?>^[^#\n]<ret>J<a-x>"cd'  # comments to %reg{c}
execute-keys -draft 'ggGj<a-x>"by'                  # lines to %reg{b}
echo "Updating %opt{kakhist_file} .."
eval %sh{
  #: $kak_opt_kakhist_file $kak_opt_kakhist_max $kak_opt_kakhist_ignore_sh $kak_opt_kakhist_debug $kak_quoted_reg_colon $kak_opt_k9s0ke_shlib_code
  . "$kak_opt_kakhist_lib_dir/kakhist.sh" --
  printf '%s\n' "$kak_reg_b" | kakhist_lines_save
}
execute-keys -draft 'gj"cp'
} } -docstring 'Save *kakhist* to file'

def kakhist-buf-help-show -override -hidden %{
  info -title '*kakhist* keys' %{
<ret>   = execute current line
<a-ret> = enter prompt with line
<esc>   = dismiss *kakhist*
'<'     = regenerate *kakhist* from history
<v?>    = show this
}
}

def kakhist-buf-show %{
  try %{ delete-buffer *kakhist* }
  edit -scratch *kakhist*
  map buffer normal <ret>   '<a-x>_: eval %reg{dot}<ret>'
  map buffer normal <a-ret> '<a-x>_: <c-r>.'
  map buffer normal <esc> ': delete-buffer!<ret>'
  map buffer normal <lt>  ': kakhist-buf-show<ret>'
  map buffer normal <gt>  ': kakhist-buf-save<ret>'  -docstring %{Save *kakhist* to history file}
  map buffer view   <?>   '<esc>: kakhist-buf-help-show<ret>'
  eval -save-regs b %{
    reg b %sh{
      eval set -- "$kak_quoted_reg_colon"
      while test $# -gt 0; do
        printf '%s\n' "$1"; shift
      done
    }
    execute-keys 'gj"bPgj'
    reg b "
## Keys: <ret> = execute line; <esc> = dismiss; <v?> = more
## History file: %opt{kakhist_file}
"
    execute-keys -draft '"bp'
    execute-keys 'vv'
  }
  kakhist-buf-help-show
} -docstring 'Show history in *kakhist* buffer'

def kakhist-init-hooks %{
  hook  -group kakhist global KakEnd      .* %{ kakhist-save }
  hook  -group kakhist global ClientClose .* %{ kakhist-save }
  #hook -group kakhist global KakBegin    .* %{ kakhist-load }
}

def kakhist-init %{
  kakhist-init-hooks
  kakhist-load
} -docstring 'Initialize kakhist'

}
