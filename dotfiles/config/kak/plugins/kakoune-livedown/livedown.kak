decl int livedown_port 8642
decl str livedown_browser ""

nop %sh{
  for dep in livedown; do
    if ! command -v $dep > /dev/null 2>&1; then
      echo "echo -debug %{Dependency unmet: $dep, please install it to use livedown.kak}"
    fi
  done
}

def livedown-start %{ nop %sh{
  (
    if test -z "$kak_opt_livedown_browser"; then
        livedown start --open --port "$kak_opt_livedown_port" "$kak_buffile"
    else
        livedown start --open --port "$kak_opt_livedown_port" --browser "$kak_opt_livedown_browser" "$kak_buffile"
    fi
  ) >/dev/null 2>&1 </dev/null &
}}

def livedown-start-with-write-on-idle %{
  livedown-start
  hook -group livedown-idle buffer InsertIdle .* %{ eval -no-hooks write }
  hook -group livedown-idle buffer NormalIdle .* %{ eval -no-hooks write }
}

def livedown-stop %{
  nop %sh{
    livedown stop --port "$kak_opt_livedown_port"
  }
  rmhooks buffer livedown-idle
}
