def -hidden grep-write-impl -params 4 %{
  eval -verbatim -no-hooks -draft -- edit -existing %arg{1}
  eval -buffer %arg{1} %{
    try %{
      # go to the target line and select it (except for \n)
      exec "%arg{2}g<semicolon>xH"
      # check for noop, and abort if it's one
      reg / %arg{3}
      exec <a-K><ret>
      # replace
      reg '"' %arg{4}
      exec R
      reg s "%reg{s}o"
    } catch %{
      reg i "%reg{i}o"
    }
  }
  eval -no-hooks -buffer %arg{1} "write; delete-buffer"
}

def grep-write -params ..1 -docstring "
apply changes specified in the current *grep* buffer to their respective file
" %{
  eval -no-hooks -save-regs 'csif' %{
    reg s ""
    reg i ""
    reg f ""
    reg c %sh{ printf grep-write-impl }
    eval -save-regs '/"' -draft %{
      # select all lines that match the *find* pattern
      exec '%3s^([^\n]+?):(\d+)(?::\d+)?:([^\n]*)$<ret>'
      eval -itersel %{
        try %{
          exec -save-regs '' <a-*>
          %reg{c} %reg{1} %reg{2} "\A%reg{/}\z" %reg{3}
        } catch %{
          reg f "%reg{f}o"
        }
      }
    }
    echo -markup %sh{
      printf "{Information}"
      s=${#kak_main_reg_s}
      [ $s -ne 1 ] && p=s
      printf "%i change%s applied" "$s" "$p"
      i=${#kak_main_reg_i}
      [ $i -gt 0 ] && printf ", %i ignored" "$i"
      f=${#kak_main_reg_f}
      [ $f -gt 0 ] && printf ", %i failed" "$f"
    }
  }
}

def grep-write-quit -docstring "
apply changes specified in the current *grep* buffer and quit
" %{
  grep-write;
  # give user a chance to see results
  menu 'quit' quit 'resume' nop 
}
