__slurp ___apos_quote_mny_code <<'EOF'
local _kq_t _kq_o; _R4_str_quote=
for _kq_t; do _kq_o=" '"
while :; do case "$_kq_t" in
*\'*)
_kq_o=$_kq_o${_kq_t%%\'*}APOSESC
_kq_t=${_kq_t#*\'} ;;
*) _kq_o=$_kq_o$_kq_t\'; break ;;
esac; done
_R4_str_quote=$_R4_str_quote$_kq_o
done
EOF

  # setup: $1=current $2=accumulator
__slurp ___apos_quote_one_code <<'EOF'
set -- "$*" ''
while :; do case "$1" in
*\'*) set -- "${1#*\'}" "$2${1%%\'*}"APOSESC ;;
*) _R4_str_quote_one="'$2$1'"; break ;;
esac; done
EOF

__fdecl_eval __str_shl_quote_one_r4 "$( __str_subst "$___apos_quote_one_code" APOSESC "\'\\\\\'\'" )"
__fdecl_eval __str_shl_quote_r4     "$( __str_subst "$___apos_quote_mny_code" APOSESC "\'\\\\\'\'" )"
__fdecl_eval __str_sql_quote_one_r4 "$( __str_subst "$___apos_quote_one_code" APOSESC "\'\'" )"
__fdecl_eval __str_sql_quote_r4     "$( __str_subst "$___apos_quote_mny_code" APOSESC "\'\'" )"

__str_shl_quote_one() {
  local _pfx _sfx; _pfx=$1; _sfx=$2; shift 2
  __str_shl_quote_one_r4 "$*"
  printf '%s' "$_pfx$_R4_str_quote_one$_sfx"
}
__str_sql_quote_one() {
  local _pfx _sfx; _pfx=$1; _sfx=$2; shift 2
  __str_sql_quote_one_r4 "$*"
  printf '%s' "$_pfx$_R4_str_quote_one$_sfx"
}

__str_shl_quote() { __str_shl_quote_r4 "$@"; printf '%s' "$_R4_str_quote"; }
__str_sql_quote() { __str_sql_quote_r4 "$@"; printf '%s' "$_R4_str_quote"; }

__sql_quote() { local _in; __slurp _in; __str_sql_quote_one "$1" "$2" "$_in"; }
__shl_quote() { local _in; __slurp _in; __str_shl_quote_one "$1" "$2" "$_in"; }

__shl_sedz_quote_one() {  # like other _one()'s; empty in -> empty out
  local esc=''
  sed -ze "s/'/'\\\\''/g" -e "1s$esc^$esc$1'$esc" -e "\$s$esc\$$esc$2'$esc"
}
__sql_sedz_quote_one() {
  local esc=''
  sed -ze "s/'/''/g" -e "1s$esc^$esc$1'$esc" -e "\$s$esc\$$esc$2'$esc"
}
__shl_sed_quote_one() {  # like other _one()'s
  printf \'; sed -e "s/'/'\\\\''/g"; printf \'
}
__sql_sed_quote_one() {
  printf \'; sed -e "s/'/''/g"; printf \'
}
