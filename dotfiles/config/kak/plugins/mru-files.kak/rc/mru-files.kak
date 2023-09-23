# some null options initialized in mru-files-init
declare-option -docstring 'Path to mru_files.txt history file' str mru_files_history "%val{config}/mru_files.txt"
declare-option -docstring 'Path to history work file (preferrably tmpfs)' str mru_files_history_tmp ''
declare-option -docstring 'Truncate MRU history after this many entries' int mru_files_max 20
declare-option -docstring 'sh code that returns success (0) if file ("$1") should NOT be saved in MRU' str mru_files_ignore_sh %{
case "$1" in
  (*/.git/[A-Z]*) return 0 ;;
esac; false
}
declare-option -docstring %{set -x in sh code} bool mru_files_debug false
declare-option -docstring %{Autosave session when clients exit?} bool mru_files_session_autosave true
declare-option -docstring %{Path to session file} str mru_files_session_file ''

provide-module mru-files %{

require-module k9s0ke-shlib

decl -hidden str-list mru_files__work_slist
decl -hidden str-list mru_files__work_str

declare-option -hidden str mru_files_sh_code %{
nl='
'
__upd_file() {  # $2 -> $1
  local d; d=${1%/*}; d=${d:-/}; [ -d "$d" ] || mkdir -p "$d"
  test -r "$2" || return 0
  if test -r "$1"; then  # maybe skip full copy
    ! test "$1" -nt "$2" || ! test "$2" -ot "$1" ||  # -nt/-ot missing failsafe
      return 0
    ! cmp -s "$1" "$2" || { touch -r "$2" "$1" || :; return 0; }
  fi
  cp -pL "$2" "$1"
}

__visit_file() {
  set -ue; set -o noglob
  vfile=$1; mrus=$2; shift 2
  __realpath1_r4 "$vfile" 2>/dev/null || exit 0  # = if inexistent dirname
  rpf=$_R4_realpath1
  __fdecl_eval __tst "$kak_opt_mru_files_ignore_sh"
  ! __tst "$rpf" || exit 0
  __mkdirp_dirname "$kak_opt_mru_files_history_tmp"
  test -r "$kak_opt_mru_files_history_tmp" || : >"$kak_opt_mru_files_history_tmp"

  case "$mrus" in
    ("$rpf$nl"*) exit 0 ;;
    (*"$nl$rpf$nl"*) __echon "$rpf$nl${mrus%%"$nl$rpf$nl"*}$nl${mrus#*"$nl$rpf$nl"}" >"$kak_opt_mru_files_history_tmp" ;;
    (*) __str_head "$rpf$nl$mrus" $kak_opt_mru_files_max >"$kak_opt_mru_files_history_tmp" ;;
  esac
}

__related() {
  set -ue
  local to end; to=$1; mrus=$2; set --
  while :; do
    set -- "$to" "$@"
    [ "${#to}" != 1 ] || break
    __str_dirandbasename_r4 "$to"; to=$_R4_1str_dirandbasename
  done
  while [ $# != 0 ]; do
    [ $# = 1 ] && end= || end=*
    __echon "$mrus" | __grepF false '' "$end" "$1" |
      sed -n -e "s/'/''/g; s/^/ '/; s/\$/'/; h" \
        -e 's/^/set -remove window mru_files__work_slist/; p; g' \
        -e 's/^/set -add    window mru_files__work_slist/; p'
    shift
  done
}
}
def-sh-with-prelude-cmd mru_files_sh mru_files_sh_code nop

define-command -override mru-files-history2tmp %{ mru_files_sh %{
  __upd_file "$kak_opt_mru_files_history_tmp" "$kak_opt_mru_files_history"
  test -r "$kak_opt_mru_files_history_tmp" || >"$kak_opt_mru_files_history_tmp"
} }
define-command -override mru-files-tmp2history %{ mru_files_sh %{
  __upd_file "$kak_opt_mru_files_history" "$kak_opt_mru_files_history_tmp"
} }

define-command -override mru-files-disable 'rmhooks global mru' -docstring 'Remove mru hooks'

def mru-files--load-history -override -hidden -params 1 %{
  try %{
    k9s0ke-file2reg  %arg{1} %opt{mru_files_history_tmp}
  } catch %{
    k9s0ke-file2reg0 %arg{1} %opt{mru_files_history} ''
  }
}

def mru-files-visit-file -params 1 -docstring %{
Mark a file as recently used
} %{ eval -save-regs b %{
  mru-files--load-history b
  mru_files_sh %{
    __job() { eval "$kak_opt_k9s0ke_shlib_code"; __visit_file "$@"; }
    if $kak_opt_mru_files_debug; then
      set -x; __job "$@"
    else      __job "$@" &
    fi
  } %arg{1} %reg{b}
} } -override -file-completion

def mru-files--mru-buf-skip-hdr -params .. %{
  try %{
    execute-keys 'gg/^[^#\n]<ret>' %arg{@}  # skip header # TODO: fails if 0 MRUs
  } catch %{
    echo -debug '0 MRUs..' %val{error}
    execute-keys 'ge'
  }
} -hidden -override

define-command mru-files-mru-buf-save -override -hidden %{
  echo "Updating %opt{mru_files_history_tmp} .."
  eval -draft %{
    buffer '*mru*'
    mru-files--mru-buf-skip-hdr 'K'
    try %{ execute-keys -draft 'Ges^[^/]<ret><a-x>d' }  # delete non-/ (including empty) lines
    execute-keys 'Ge'
    echo -to-file %opt{mru_files_history_tmp} %reg{dot}
    execute-keys 'ge<a-o>'  # restore final empty line
  }
  #mru-files-tmp2history  # TODO: needs different message, might clobber persistent history
}

define-command -override mru-files-session-save -params 0..1 -file-completion %{
eval -draft -save-regs b %{
  reg b %sh{ pwd }
  cd /
  k9s0ke-shlib-eval %{
    set -ue; set -o noglob
    ses=${1:-$kak_opt_mru_files_session_file}
    [ 0 -ne ${#ses} ] || exit 0
    __mkdirp_dirname "$ses"; exec >"$ses"
    eval set -- "$kak_quoted_buflist"
    for f; do
      case "$f" in ('*'*'*') continue ;; esac
      __str_sql_quote_one 'edit ' '
' "$f"
    done
  } %arg{1}
  cd %reg{b}
} }  -docstring "
session-save [<file>]: save list of open buffers
  Current session file:
    %opt{mru_files_session_file}
  To restore the buffers, source the session file
"
define-command -override mru-files-session-load -params 0..1 -file-completion %{
  source %sh{ echo "${1:-$kak_opt_mru_files_session_file}" }
} -docstring "
Source the argument, or if unspecified:
  %opt{mru_files_session_file}
"

define-command mru-files-mru-buf-show-help -override -hidden %{
  info -title '*mru* keys' %{
<esc>   = dismiss *mru*
<ret>   = open file under cursor
<a-ret> = open in background buffer
'='     = move related files to top
'>'     = save *mru* to history file
'<'     = re-run mru-files-list
<v?>    = show this
}
}

define-command mru-files -override -params 0..1 -shell-script-candidates %{ cat "$kak_opt_mru_files_history_tmp" 2>/dev/null } -docstring %{Show MRU list (<ret>) or complete recent file} %{
  %sh{
    case $# in
      0) echo mru-files-list ;;
      1) echo edit ;;
    esac
  } %arg{@}
}
define-command mru-files-open-cline -hidden %{
  buffer '*mru*'
  execute-keys -with-maps -with-hooks '<ret>'
}
define-command mru-files-list -override -docstring %{Show MRU list} %{
  try %{ delete-buffer *mru* }
  edit -scratch *mru*
  map buffer normal <ret>     '; <a-x>_: edit %reg{dot}<ret>'  -docstring %{Open file}
  map buffer normal <a-ret>   '; <a-x>_: eval -draft -verbatim edit %reg{dot}<ret>'  -docstring %{Open file in background buffer}
  map buffer normal <esc>     ': delete-buffer!<ret>'  -docstring %{Dismiss *mru*}
  map buffer normal <gt>      ': mru-files-mru-buf-save<ret>'  -docstring %{Save *mru* to history file}
  map buffer normal <lt>      ': mru-files-list<ret>'  -docstring %{re-run mru-files-list}
  map buffer normal '='       ': mru-files-related<ret>' -docstring %{group related *mru* files}
  map buffer view   <?>       '<esc>: mru-files-mru-buf-show-help<ret>'  -docstring %{Show *mru* buffer help}
  evaluate-commands -save-regs b %{
    mru-files--load-history b
    execute-keys 'gg"bPgg'
    reg b "
## Temp history file:  %opt{mru_files_history_tmp}
## Persistent history: %opt{mru_files_history}
## Keys: <ret> = open file; <esc> = dismiss; <v?> = more
"
    execute-keys -draft 'gg"bP<a-O>ggd'
    execute-keys "k%val{count}j"
    try %{
      execute-keys -draft "%val{count}s.<ret>"
    } catch %{
      # TODO: should be refreshed before <ret> too, but we've just created it
      mru-files-open-cline
      delete-buffer '*mru*'
    }
  }
  mru-files-mru-buf-show-help
}

def mru-files--0a -params 0..0 %{nop --} -hidden -override
def mru-files--streq-try -params 4 %{
  set global mru_files__work_slist %arg{1}
  set -remove global mru_files__work_slist %arg{2}
  try %{
    mru-files--0a %opt{mru_files__work_slist}
    eval %arg{3}
  } catch %{ eval %arg{4} }
} -hidden -override

def mru-files--rev-join -params .. %{
  try %{ mru-files--0a %arg{@}; set window mru_files__work_str } catch %{
  set -remove window mru_files__work_slist %arg{1}
  mru-files--rev-join %opt{mru_files__work_slist}
  set         window mru_files__work_str "%opt{mru_files__work_str}
%arg{1}"
  }
} -override -hidden

def mru-files-related -docstring %{
} %{
  try %{ buffer *mru* } catch %{ mru-files-list }
  eval -save-regs b %{
    mru-files--load-history b
    set window mru_files__work_slist
    exec '; <a-x>_'
    eval -- %sh{
      eval "$kak_opt_k9s0ke_shlib_code"; eval "$kak_opt_mru_files_sh_code";
      __related "$kak_reg_dot" "$kak_reg_b"
    }
    mru-files--rev-join %opt{mru_files__work_slist}
    reg b %opt{mru_files__work_str}
    mru-files--mru-buf-skip-hdr 'Ged"bPge<a-o>'
    mru-files--mru-buf-skip-hdr
  }
} -override

# will record buffer active when idle hook runs (maybe != active when invoked)
define-command mru-files-delayed-update %{
  hook -once -group mru-files buffer NormalIdle .* %{
    mru-files-visit-file %val{buffile}
  }
} -override -hidden

define-command mru-files-init -override %{
  eval -- %sh{
    # strictly speaking, we should kak-quote paths in returned commands
    [ 0 -ne ${#kak_opt_mru_files_history_tmp} ] ||
      printf "%s %s%s%s\n" 'set global mru_files_history_tmp' '%<' "${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}/user/$(id -un)}"/kakoune-tmp/mru_files.txt '>'
    [ 0 -ne ${#kak_opt_mru_files_session_file} ] ||
      printf "%s %s%s%s\n" 'set global mru_files_session_file' '%<' "$HOME/.local/share/kak/mru/mru_files_session.kak" '>'
  }

  mru-files-disable
  mru-files-history2tmp
  hook global KakEnd      .* -group mru-files %{ mru-files-tmp2history }

  hook global ClientClose .* -group mru-files %{
    mru-files-tmp2history
    mru-files--streq-try %opt{mru_files_session_autosave} true %{
      mru-files-session-save
    } %{}
  }
  hook global WinDisplay [^*].* -group mru-files %{ mru-files-delayed-update }
}

mru-files-init

}
