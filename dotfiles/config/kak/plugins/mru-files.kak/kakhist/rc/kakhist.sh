set -euf
! ${kak_opt_kakhist_debug:-false} || set -x

# delimit part already in history file -- _save() ignores everything before marker
# would be nice to use 'kakhist-save' itself, but maybe that's what the user just entered & is being executed; or maybe it was auto-inserted
# so use a different marker; ':  ...' wouldn't make it into history if typed
_hist_loaded='    kakhist-save'

# (1) remove loaded history if present, filter out dupes etc (2) append to old history & save
__save_filter() {
  local oldcmd; local h0; oldcmd=; h0=$(cat "$kak_opt_kakhist_file")
  eval set -- '"$_hist_loaded"' "$h0" '"$@"'
  for cmd; do  # rebuild $@; 'for' duplicates $@; need $1 = $_hist_loaded marker to clear existing "$@"
    case "$cmd" in
      "$_hist_loaded")
        eval set -- "$h0"
        eval cmd=\${$#}
        ;;
      "$oldcmd"|'kakhist-save') ;;  # ignore
      *) __tst "$cmd" || set -- "$@" "$cmd" ;;
    esac
    oldcmd=$cmd
  done

  test $# -le "$kak_opt_kakhist_max" || shift $(( $# - $kak_opt_kakhist_max ))
  __str_shl_quote "$@" >"$kak_opt_kakhist_file"
}

__load_tst() {
  eval "__tst() { $kak_opt_kakhist_ignore_sh $(printf '\n%s' 'return $?;') } "
}

kakhist_save() {
  eval last=\${$#}; test "$_hist_loaded" != "$last" || return 0
  eval "$kak_opt_k9s0ke_shlib_code"
  __load_tst
  mkdir -p "${kak_opt_kakhist_file%/*}"/; >> "$kak_opt_kakhist_file"
  __save_filter "$@"
  echo "reg colon '$_hist_loaded'"  # insert marker
}

kakhist_lines_save() {
  local _ll
  while IFS= read -r _ll; do
    set -- "$@" "$_ll"
  done
  kakhist_save "$@"
}

kakhist_load() {
  eval "$kak_opt_k9s0ke_shlib_code"
  __load_tst
  mkdir -p "${kak_opt_kakhist_file%/*}"/; >> "$kak_opt_kakhist_file"
  eval set -- "$(cat "$kak_opt_kakhist_file")"
  eval last=\${$#}; test "$_hist_loaded" = "$last" || set -- "$@" "$_hist_loaded"  # insert marker

  __str_sql_quote "$@"
}
