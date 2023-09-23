#!/bin/sh
set -u

src=$(cat "${0%/*}/k9s0ke-shlib.sh")

rc2shbool() {
  [ $1 -eq 0 ] && echo true || echo false
}

has_substr() {
  [ bc = "$(x=abcd; echo "${x:1:2}")" ] 2>/dev/null
}
has_read_stdin() {
  [ 'b c' = "$(printf %s\\n a 'b c' d | (IFS= read -r -d '' str </dev/stdin; printf %s\\n "$str") | head -n 2 | tail -n 1" ]
}

for ft in has_substr has_read_stdin; do
  set -x; $ft; hasrc=$?; set +x  # eval "$ft=\$(rc2shbool $hasrc)"
  if $(rc2shbool $hasrc); then
    src=$(printf '%s\n' "$src" | sed -e "/ ##$ft=false"'$/d' -e "/ ##$ft=true"'$/s/##*//')
  fi
done

! bash --pretty-print </dev/null >/dev/null 2>&1 ||
  src="$(printf '%s\n' "$src" | bash --pretty-print | sed -e 's/     *//')"

printf '%s\n' "$src" #| tee "${0%/*}/k9s0ke-shlib-optimized.sh"
echo 1>&2 'k9s0ke-shlib: optimization done'
