__shell_set_o_query() {  # args: '{+|-}o opt' # e.g. '-o errexit'
  case "$(set +o) " in
    *"$1"[!A-Za-z0-9_-]*) return 0 ;;
    *) return 1 ;;
  esac
}

__assign_var() { eval "$1=\$2"; }
__copy_var() {  # args: src dst
  [ "$1" = "$2" ] || eval "$1=\$$2"  # x=$x harmless but possibly slow
}

__str_join_ch_r4() {  # args: delim-char-or-'' str...
  [ $# -gt 2 ] || { _R4_str_join_ch=${2:-}; return 0; }
  local _s; _s=$IFS
  IFS=$1; shift
  _R4_str_join_ch=$*
  IFS=$_s
}
__str_join_ch_ref() {
  __str_join_ch_r4 "$@"
  __assign_var "$1" "$_R4_str_join_ch"
}

  # echo / echo -n without switches; unlike printf '%s ' ..., no final ' ', no 0-arg problems
__echo()  { __str_join_ch_r4 ' ' "$@"; printf %s\\n "$_R4_str_join_ch"; }
__echon() { __str_join_ch_r4 ' ' "$@"; printf %s    "$_R4_str_join_ch"; }
__echo_lines()  { [ $# -eq 0 ] || printf %s\\n "$@"; }
__echon_lines() { [ $# -eq 0 ] || printf %s   "$@"; }

__herestring() {  # args: herestring cmd...
  local _k9s0ke_shlib_hstr; _k9s0ke_shlib_hstr=$1; shift
  "$@" <<EOF
$_k9s0ke_shlib_hstr
EOF
}
__slurp_out_rc() {  # args: outvar rcvar cmd...
  set -- "$1" "$2" "$(shift 2; set +e; "$@"; printf '%s' k9s0keshlib-eof$?; exit 0)"  # no trimming of final \n
  __assign_var "$1" "${3%k9s0keshlib-eof*}"
  if [ "${#2}" != 0 ]; then
    # if cmd is a function that calls exit, the output won't be terminated
    eval "[ \${#$1} -lt \${#3} ]" || set -- "$1" "$2" ''
    __assign_var "$2" "${3##*k9s0keshlib-eof}"
  fi
}
__slurp_cat() { set -- "$1" "$(cat; printf X)"; __assign_var "$1" "${2%X}"; } ##has_read_stdin=false
#__slurp_cat() { IFS= read -r -d '' /dev/stdin "$1" || :; } ##has_read_stdin=true
__slurp_readline_r4() {
  _R4_slurp_readline=
  while :; do
    __readline_r4
    _R4_slurp_readline=$_R4_slurp_readline$_R4_1readline
    ! "$_R4_2readline" || break
  done
}
__slurp() { __slurp_readline_r4; __assign_var "$1" "$_R4_slurp_readline"; } ##has_read_stdin=false
#__slurp() { __slurp_cat "$@"; } ##has_read_stdin=true

__readline_r4() {  # args: # none # _R4_: 1=line 2=eof
  if IFS= read -r _R4_1readline; then _R4_1readline=$_R4_1readline'
'; _R4_2readline=false; else _R4_2readline=true; fi
}
__readline_ref() {  # args: line eof
  __readline_r4
  copy_var "$1" _R4_1readline
  copy_var "$2" _R4_2readline
}

__wcl() {  # args: # none
  __wcl_r4 "$@"; echo "$_R4_wcl"
}
__wcl_r4() {
  local _hl; _R4_wcl=0
  while IFS= read -r _hl; do _R4_wcl=$((_R4_wcl + 1)); done
  # wc -l also doesn't count non-\n terminated last line
}
__head() {  # args: n
  while [ "$1" -gt 0 ]; do
    __readline_r4; set -- $(( $1 - 1 ))
    __echon "$_R4_1readline"
    ! "$_R4_2readline" || break
  done
}
__str_head1() {  # args: str
  __str_head "$1" 1
}
__str_head() {  # args: str n
  local _hl
  while [ "${#1}" != 0 ]; do
    [ "$2" -gt 0 ] || break
    _hl=${1%%'
'*}
    if [ ${#_hl} = ${#1} ]; then
      printf '%s' "$_hl"
      break
    else
      printf '%s\n' "$_hl"
      set -- "${1#*'
'}" $(( $2 - 1 ))
    fi
  done
}
  # like tail +n # skips ($n-1) lines
__tail_plus() {  # args: n # tail -n +$1
  while :; do
    __readline_r4
    [ "$1" -gt 1 ] || __echon "$_R4_1readline"
    set -- $(( $1 - 1 ))
    ! "$_R4_2readline" || break
  done
}
  # like tail -$1; unlike tail, even -0, still consume input
__tail() { # args: n # tail -$1
  local _tn; _tn=$1; set --
  while :; do
    __readline_r4
    if "$_R4_2readline"; then  # eof: process unterminated line if != ''
      [ "${#_R4_1readline}" != 0 ] || break
    fi
    set -- "$@" "$_R4_1readline"
    [ $# -le "$_tn" ] || shift
    ! "$_R4_2readline" || break
  done
  __echon_lines "$@"
}
__tail1() { __tail 1; }
__tac() {  # args: # none
  set --
  while :; do
    __readline_r4
    set -- "$_R4_1readline" "$@"
    ! "$_R4_2readline" || break
  done
  __echon_lines "$@"
}

__grepF() {  # args: v x1 x2 str # v=true: grep -v # x='*': grep -F; x='': grep -Fx
  local v x1 x2; v=$1; x1=$2; x2=$3; shift 3
  local _gl _glnl _eof=false _rc=1  # output $_glnl, but grep in _gl
  while ! $_eof; do
    if IFS= read -r _gl; then _glnl=$_gl'
'; else _eof=true; _glnl=$_gl; fi
    #shellcheck disable=SC2254
    case "$_gl" in
      ($x1"$1"$x2) $v || __echon "$_glnl"; _rc=0 ;;
      (*)        ! $v || __echon "$_glnl"; _rc=0 ;;
    esac
  done
  return $_rc
}
  # like grep -E; uses shell patterns, not regex'es
__grepSHPAT() {  # args: v x1 x2 shpat # v=true: grep -v # x='*': grep; x='': grep -x
  local v x1 x2; v=$1; x1=$2; x2=$3; shift 3
  local _gl _glnl _eof=false _rc=1
  while ! $_eof; do
    if IFS= read -r _gl; then _glnl=$_gl'
'; else _eof=true; _glnl=$_gl; fi
    #shellcheck disable=SC2254
    case "$_gl" in
      ($x1$1$x2) $v || __echon "$_gl"; _rc=0 ;;
      (*)      ! $v || __echon "$_gl"; _rc=0 ;;
    esac
  done
  return $_rc
}

  # e.g. k9s0ke-shlib-eval %{ printf '%s\n' ' a b c ' 'x   y z' | __fieldparse_eval 'printf "%s %s\n" "$3" "$2"' }
  # won't expand globs, but will expand ~
__fieldparse_eval() {
  local _eof=false code; code=$1; shift
  eval "$(__fdecl __fpl_aux "$code")"
  while ! $_eof; do
    if IFS= read -r _fpl; then _fpl=$_fpl'
'; else _eof=true; fi
    ! $_eof || [ "${#_fpl}" != 0 ] || break
    local __fpeval_local_seto="$(set +o)"; set -o noglob; [ -z "${ZSH_VERSION:-}" ] || set -o shwordsplit
    set -- $_fpl; eval "$__fpeval_local_seto"
    __fpl_aux "$@"
  done
}

__str_subst() {  # args: text FIND REPLACE
  local text find repl; find=$2; repl=$3  #; set -- "$1"
  [ "${#find}" != 0 ] || return 1
  while :; do
    text=${1%%"$find"*}  # text-b4-FIND
    [ ${#text} -ne ${#1} ] || break
    printf '%s' "$text$repl"
    set -- "${1#"$text$find"}"  ##has_substr=false
    #set -- "${1:$(( ${#text} + ${#find} ))}" ##has_substr=true
  done
  printf '%s' "$1"
}
__str_repeat() {  # args: n str
  local _n; _n=$1; shift
  [ "$_n" -gt 0 ] && [ "${#1}" != 0 ] || return 0
  if [ -z "${1#?}" ]; then
    local _tr; _tr=$1
    [ "$_tr" != \\ ] || _tr=\\$_tr
    printf "%${_n}s" ' ' | tr ' ' "$_tr"
  else
    while [ "$_n" -gt 0 ]; do _n=$(( _n - 1 )); printf %s "$1"; done
  fi
}
__str_repeat_simple_r4() {  # args: n str
  [ "$1" -gt 0 ] && [ ${#2} -gt 0 ] || { _R4_str_repeat=; return; }
  local _s0; _s0=$2
  while [ "$1" -gt 1 ]; do set -- $(( $1 - 1 )) "$2$_s0"; done
  _R4_str_repeat=$2
}
__str_repeat_simple_ref() {  # args: outvar n str
  __str_repeat_simple_r4 "$2" "$3"
  __assign_var "$1" "$_R4_str_repeat"
}
__aux_str_repeat_r4() {  # args [_n] _p2n _p2s
  # _n declared top level, available in recursion
  [ $# -eq 2 ] || { local _n; _n=$1; shift; }
  local _nn; _nn=$(( $1 + $1))
  if [ "$_nn" -le "$_n" ]; then __aux_str_repeat_r4 $_nn "$2$2"; fi
  if [ "$1" -le "$_n" ]; then _n=$(( _n - $1 )); _R4_str_repeat=$_R4_str_repeat$2; fi
}
__str_repeat_r4() {  # args: n str
  _R4_str_repeat=
  [ "$1" -gt 0 ] && [ ${#2} -gt 0 ] || return 0
  if [ "$1" -lt 4 ]; then __str_repeat_simple_r4 "$@"; return; fi
  __aux_str_repeat_r4 "$1" 1 "$2"
}
__str_repeat_ref() {  # args: outvar n str
  __str_repeat_r4 "$2" "$3"
  __assign_var "$1" "$_R4_str_repeat"
}
__str_strip_lead_r4() {  # args: str chars # like sed -e "s/^[$c]*//"
  local patyy patno; patyy="[$2]"; patno="[!$2]"
  set -- "${1#$patyy}"  # optimizations, not required
  set -- "${1#$patyy}"
  case "$1" in
    $patyy*$patno*) set -- "${1#"${1%%$patyy*}"}" ;;
    $patyy*) set -- '' ;;
  esac
  _R4_str_strip_lead=$1
}
__str_strip_trail_r4() {  # args: str chars # like sed -e "s/[$c]*$//"
  local patyy patno; patyy="[$2]"; patno="[!$2]"
  set -- "${1%$patyy}"  # optimizations, not required
  set -- "${1%$patyy}"
  case "$1" in
    *$patno*$patyy) set -- "${1%"${1##*$patno}"}" ;;
    *$patyy) set -- '' ;;
  esac
  _R4_str_strip_trail=$1
}
__str_strip_trail_slash_r4() {  # args: str  # like _trail /, but keep root /
  __str_strip_trail_r4 "$1" /
  _R4_str_strip_trail_slash=${_R4_str_strip_trail:-/}
}
  # $_R4_ = . | ..[/..]* | [path/]fname
  # __str function; in reality /path/x/.. != /path (symlink)
__str_path_canon_end_r4() {  # args: path
  set +x
  local eat=0
  while [ ${#1} != 0 ]; do case "$1" in
    # these must work regardless of eat
    /..)  set -- / ;;
    *?/)  set -- "${1%/}" ;;  # doesn't apply to naked-/
    */.)  set -- "${1%.}" ;;  # /. -> /
    */..) set -- "${1%/..}"; eat=$(( eat + 1 )) ;;
    # these handle eat
    *)  # naked-. or naked-/; or [path/]fname
      if [ "$eat" != 0 ]; then
        case "$1" in
          */*) set -- "${1%/*}"/; eat=$(( eat - 1 )) ;;  # /eatme -> /
          .|/)
            set -- "${1#.}"  # if ., eat it
            __str_repeat_simple_r4 "$eat" ../
            set -- "$1${_R4_str_repeat%/}"
            break ;;
          *) set -- .; eat=$(( eat - 1 )) ;;  # eatme -> .
        esac
      else break
      fi ;;
  esac; done
  _R4_str_path_canon_end=$1
  set +x
}
  # *apparent* dirname / basename for a file (won't handle */..)
  # this is a __str function and does not check real paths
__str_dirandbasename_r4() {  # args: path # result: _R4_1=$dirname _R4_2=$after/
  __str_strip_trail_slash_r4 "$1"; set -- "$_R4_str_strip_trail_slash"
  case "$1" in
   (*/*)
      _R4_1str_dirandbasename=${1%/*}
      : "${_R4_1str_dirandbasename:=/}"
      _R4_2str_dirandbasename=${1##*/} ;;
     (*)
      _R4_1str_dirandbasename=.
      _R4_2str_dirandbasename=$1 ;;
  esac
}


__fdecl() {  # args: fn body
  printf '%s\n}' "$1() { $2"
}
__fdecl_eval() {  # args: fn body
  eval "$1() { $2"'
}'
}

__abspath1() {  # args: path
  __abspath1_r4 "$1"
  printf '%s' "$_R4_abspath1"
}
  # won't canonicalize path (does strip end-/)
__abspath1_r4() {  # args: path
  case "$1" in (/*) ;; (*) set -- "${PWD%/}/$1" ;; esac
  __str_strip_trail_slash_r4 "$1"
  _R4_abspath1=$_R4_str_strip_trail_slash
}
__abspath1_ref() {  # args: outvar path
  __abspath1_r4 "$2"
  __assign_var "$1" "$_R4_abspath1"
}
__dirname_abs_r4() {  # args: path
  __abspath1_r4 "$1"
  _R4_dirname=${_R4_abspath1%/*}
  : "${_R4_dirname:=/}"
}

__mkdirp() {  # args: path
  case "$1" in
    '') return 1 ;;
    .|/) ;;  # '..' too?
    *) [ -d "$1" ] || mkdir -p "$1" ;;
  esac
}
  # like `mkdir -p $(dirname $1)` but mkdir -p x/../y creates both x and y
__mkdirp_dirname() {  # args: path
  __str_dirandbasename_r4 "$1"
  __mkdirp "$_R4_1str_dirandbasename"
}

  # __realpath1() { realpath "$(__abspath1 "$1")"; } # because busybox realpath has no --

  # leaves $PWD temporarily -> if already 'rm -rf'd, might disappear!
__realpath1_r4() {  # args: path # like realpath, `dirname $1` must exist
  local d _pwdin; _pwdin=$PWD; _R4_realpath1=
  [ $# != 0 ] && [ "${#1}" != 0 ] || return 1
  if cd -P -- "$1" >/dev/null 2>&1; then  # cd -P: later $PWD not $(pwd -P)
    set -- ''
  else  # not a dir: last '/'-fragment must be file, even if $1 = */./*, /../ etc
    __str_dirandbasename_r4 "$1"
    cd -P -- "$_R4_1str_dirandbasename" >/dev/null 2>&1 ||
      return 1  # all cd's failed so far; $PWD = $_pwdin
    set -- "$_R4_2str_dirandbasename"
  fi  # here $PWD=dirname, 1=after-last-/
  # strip all leading /'s; some shells (bash) won't collapse initial //'s
  __str_strip_lead_r4 "$PWD" /; d=$_R4_str_strip_lead
  # here $d and $1 possibly empty path components; join with '/' separator
  set -- "${d:+/}$d${1:+/}$1"
  _R4_realpath1=${1:-/}  # if both were empty, still one /
  cd -- "$_pwdin"
}
__realpath1() {
  __realpath1_r4 "$@" && printf '%s\n' "$_R4_realpath1" || return $?
}

  # like which / command -v # no builtins # no hashing # useless as "optimized" PATH search before exec(); maybe 'command -v' broken
__command_v_r4() {  # args: bin PATH
  case "$1" in (*/*)
    _R4_command_v=$1
    [ -x "$1" ] && [ -f "$1" ] && [ -r "$1" ] &&
      return 0 || return 1
  ;; esac
  local p
  while [ "${#2}" != 0 ]; do
    case "$2" in
      (*:*) p=${2%%:*}; set -- "$1" "${2#*:}" ;;
      (*) p=$2; set -- "$1" '' ;;
    esac
    [ "${#p}" != 0 ] && __command_v_r4 "$p/$1" && return 0 || continue
  done
  return 1
}

  #if [ "${ZSH_VERSION:-}" ]; then set -o shwordsplit posixcd 2>/dev/null || :; fi
