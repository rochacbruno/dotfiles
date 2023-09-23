declare-option str focus_separator "{Whitespace}────────────────────────────────────────────────────────────────────────────────"
declare-option int focus_context_lines 1
declare-option -hidden range-specs focus_hidden_lines
declare-option -hidden str-list focus_selections
declare-option -hidden bool focus_enabled false

define-command focus-selections -docstring "Focus on selections" %{
    # save selections with timestamp using a temporary mark register
    evaluate-commands -save-regs f %{
        execute-keys <">fZ
        set-option window focus_selections %reg{f}
    }

    set-option window focus_hidden_lines
    evaluate-commands -draft %{
        try %{
            evaluate-commands %sh{ [ "$kak_opt_focus_context_lines" -gt 0 ] || echo fail }
            execute-keys <a-:> %opt{focus_context_lines} J
            execute-keys <a-semicolon> %opt{focus_context_lines} K
        }
        try %{ invert-lines } catch %{ fail "focus: All lines selected, cannot focus" }

        # remove single EOL and end of selection EOL
        execute-keys <a-:> <a-K>\A\n\z<ret> H

        # remove single line selections
        execute-keys <a-k>\n<ret>

        set-option window focus_hidden_lines %val{timestamp} "%val{selection_desc}|%opt{focus_separator}"
        try %{
            execute-keys <a-,>
            evaluate-commands -itersel %{
                set-option -add window focus_hidden_lines "%val{selection_desc}|%opt{focus_separator}"
            }
        }

        try %{ add-highlighter window/focus-hidden replace-ranges focus_hidden_lines }
    }
    echo -markup "{Information}focus: Focused selections"
    set-option window focus_enabled true
}

define-command focus-extend -docstring "Extend focus area with current selections" %{
    evaluate-commands -draft -save-regs cp %{
        # restore previous selections through a temporary mark register and append current ones
        execute-keys <">cZ
        try %{
            set-register p %opt{focus_selections}
            execute-keys <">pz
            execute-keys <">c<a-z>a <a-_>
        }

        focus-selections
    }
}

define-command focus-clear -docstring "Clear selection focus" %{
    set-option window focus_selections
    remove-highlighter window/focus-hidden
    echo -markup "{Information}focus: Cleared focus"
    set-option window focus_enabled false
}

define-command focus-toggle -docstring "Toggle selection focus" %{
    evaluate-commands %sh{ [ "$kak_opt_focus_enabled" = "true" ] && echo "focus-clear" || echo "focus-selections" }
}

define-command -hidden invert-lines %{
    execute-keys x<a-:>

    # sort selections by descriptors
    evaluate-commands %sh{
        printf "select "
        printf "%s\n" "$kak_selections_desc" | tr ' ' '\n' | sort -n -t. | tr '\n' ' '
    }

    # select line intervals outside selections
    evaluate-commands %sh{
        printf 'select'
        eval "set -- $kak_quoted_selections_desc"
        i=1
        start=${1%%.*}; end=${1#*,}; end=${end%.*}
        shift
        while [ $i -le "$kak_buf_line_count" ]; do
            if [ $i -lt "$start" ]; then  # not yet at next selection, select until its beginning
                printf ' %s.1,%s.1' $i $(( start - 1 ))
                i=$start
            else  # encountered a selection, skip to its end
                i=$(( end + 1 ))
                if [ $# -gt 0 ]; then
                    start=${1%%.*}; end=${1#*,}; end=${end%.*}
                    shift
                else  # all selections done, select until end of buffer
                    start=$(( kak_buf_line_count + 1 ))
                fi
            fi
        done
    }
    execute-keys x<a-_>
}

alias global focus-enable focus-selections
alias global focus-disable focus-clear
