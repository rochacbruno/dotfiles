provide-module byline %{

# Mappings

map global "normal" "x" ": byline-drag-down<ret>"
map global "normal" "X" ": byline-drag-up<ret>"

# High-level selection expanding and contracting, based on selection direction

define-command -hidden byline-drag-down %{
  evaluate-commands -itersel -no-hooks %{
    try %{
      byline-assert-selection-forwards
      byline-expand-below
    } catch %{
      byline-contract-above
    }
  }
}

define-command -hidden byline-drag-up %{
  evaluate-commands -itersel -no-hooks %{
    try %{
      byline-assert-selection-forwards
      byline-contract-below
    } catch %{
      byline-expand-above
    }
  }
}

# Assertions

define-command -hidden byline-assert-selection-reduced %{
  # Selections on blank lines are not considered reduced
  execute-keys -draft "<a-K>^$<ret>"
  # Single-character selections are reduced
  execute-keys -draft "<a-k>\A.{,1}\z<ret>"
}

define-command -hidden byline-assert-selection-forwards %{
  try %{
    # If the selection is just the cursor, we treat it as being in the forwards
    # direction, and can exit early
    byline-assert-selection-reduced
  } catch %{
    # Otherwise, we need to inspect the selection
    evaluate-commands -no-hooks %sh{
      cursor_row=$(echo "$kak_selection_desc" | cut -d "," -f 2 | cut -d "." -f 1)
      anchor_row=$(echo "$kak_selection_desc" | cut -d "," -f 1 | cut -d "." -f 1)
      [ "$cursor_row" -gt "$anchor_row" ] && exit
      [ "$cursor_row" -lt "$anchor_row" ] && (echo "fail"; exit)
      anchor_col=$(echo "$kak_selection_desc" | cut -d "," -f 1 | cut -d "." -f 2)
      cursor_col=$(echo "$kak_selection_desc" | cut -d "," -f 2 | cut -d "." -f 2)
      [ "$cursor_col" -lt "$anchor_col" ] && (echo "fail"; exit)
    }
  }
}

define-command -hidden byline-assert-selection-full-lines %{
  # Starts at beginning of line
  execute-keys -draft "<a-:><a-;>;<a-k>\A^<ret>"
  # Ends at end of line
  execute-keys -draft "<a-:>;<a-k>$<ret>"
}

# Low-level selection expanding and contracting primitives

define-command -hidden byline-expand-above %{
  try %{
    byline-assert-selection-full-lines
    execute-keys "<a-:><a-;>%val{count}Kx"
  } catch %{
    execute-keys "x<a-:><a-;>"
    evaluate-commands -no-hooks %sh{
      if [ "$kak_count" -gt 1 ]; then
        echo "execute-keys '$((kak_count - 1))Kx'"
      fi
    }
  }
}

define-command -hidden byline-contract-above %{
  try %{
    byline-assert-selection-full-lines
    execute-keys "<a-:><a-;>%val{count}Jx"
  } catch %{
    try %{
      execute-keys "<a-x>"
    } catch %{
      execute-keys "x"
    }
    execute-keys "<a-:><a-;>"
    evaluate-commands -no-hooks %sh{
      if [ "$kak_count" -gt 1 ]; then
        echo "execute-keys '$((kak_count - 1))Jx'"
      fi
    }
  }
}

define-command -hidden byline-expand-below %{
  try %{
    byline-assert-selection-full-lines
    execute-keys "<a-:>%val{count}Jx"
  } catch %{
    execute-keys "x<a-:>"
    evaluate-commands -no-hooks %sh{
      if [ "$kak_count" -gt 1 ]; then
        echo "execute-keys '$((kak_count - 1))Jx'"
      fi
    }
  }
}

define-command -hidden byline-contract-below %{
  try %{
    byline-assert-selection-full-lines
    execute-keys "<a-:>%val{count}Kx"
  } catch %{
    try %{
      execute-keys "<a-x>"
    } catch %{
      execute-keys "x"
    }
    execute-keys "<a-:>"
    evaluate-commands -no-hooks %sh{
      if [ "$kak_count" -gt 1 ]; then
        echo "execute-keys '$((kak_count - 1))Kx'"
      fi
    }
  }
}

}
