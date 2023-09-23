# search for a regex pattern among all opened buffers
# similar to grep.kak

decl str toolsclient
decl str jumpclient
decl -hidden int find_current_line 0

def -params ..1 -docstring "
find [<pattern>]: search for a pattern in all buffers
If <pattern> is not specified, the content of the main selection is used
" find %{
    try %{
        eval %sh{ [ -z "$1" ] && echo fail }
        reg / %arg{1}
    } catch %{
        exec -save-regs '' '*'
    }
    eval -draft -save-regs '"' %{
        try %{ delete-buffer *find* }
        # debug so that it's not included in the iteration
        edit -scratch -debug *find-tmp*
        eval -no-hooks -buffer * %{
            try %{
                exec '%s<ret>'
                # merge selections that are on the same line
                exec '<a-s><a-L><a-;>;'
                eval -save-regs 'c"' -itersel %{
                    reg c "%val{bufname}:%val{cursor_line}:%val{cursor_column}:"
                    # expand to full line and yank
                    exec -save-regs '' '<semicolon>xHy'
                    # paste context followed by the selection
                    # older Kakoune doesn't select pasted text so make sure we
                    # to move the cursor to the end of the pasted text after P
                    exec -buffer *find-tmp* 'geo<esc>"cPhglp'
                }
            }
        }
        exec -save-regs '' 'd%y'
        delete-buffer *find-tmp*
        edit -scratch *find*
        exec R
        set buffer find_current_line 0
        addhl buffer/ regex "%reg{/}" 0:black,yellow
        # final so that %reg{/} doesn't get highlighted in the header
        addhl buffer/ regex "^([^\n]+):(\d+):(\d+):" 1:cyan,default+F 2:green,default+F 3:green,default+F
        addhl buffer/ line '%opt{find_current_line}' default+b
        map buffer normal <ret> :find-jump<ret>
    }
    eval -try-client %opt{toolsclient} %{
        buffer *find*
    }
}


def -hidden find-apply-impl -params 4 %{
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
}
def -hidden find-apply-force-impl -params 4 %{
    try %{
        find-apply-impl %arg{@}
    } catch %{
        # the buffer wasn't open: try editing it
        # if this fails there is nothing we can do
        eval -verbatim -no-hooks -draft -- edit -existing %arg{1}
        find-apply-impl %arg{@}
        eval -no-hooks -buffer %arg{1} "write; delete-buffer"
    }
}

def find-apply-changes -params ..1 -docstring "
find-apply-changes [-force]: apply changes specified in the current buffer to their respective file
If -force is specified, changes will also be applied to files that do not currently have a buffer
" %{
    eval -no-hooks -save-regs 'csif' %{
        reg s ""
        reg i ""
        reg f ""
        reg c %sh{ [ "$1" = "-force" ] && printf find-apply-force-impl || printf find-apply-impl }
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

def -hidden find-jump %{
    eval %{
        try %{
            exec -save-regs '' '<semicolon>xs^([^\n]+):(\d+):(\d+):<ret>'
            set buffer find_current_line %val{cursor_line}
            eval -try-client %opt{jumpclient} -verbatim -- edit -existing %reg{1} %reg{2} %reg{3}
            try %{ focus %opt{jumpclient} }
        }
    }
}

def find-next-match -docstring 'Jump to the next find match' %{
    eval -try-client %opt{jumpclient} %{
        buffer '*find*'
        exec "%opt{find_current_line}ggl/^[^\n]+:\d+:\d+:<ret>"
        find-jump
    }
    try %{ eval -client %opt{toolsclient} %{ exec %opt{find_current_line}g } }
}

def find-previous-match -docstring 'Jump to the previous find match' %{
    eval -try-client %opt{jumpclient} %{
        buffer '*find*'
        exec "%opt{find_current_line}g<a-/>^[^\n]+:\d+:\d+:<ret>"
        find-jump
    }
    try %{ eval -client %opt{toolsclient} %{ exec %opt{find_current_line}g } }
}
