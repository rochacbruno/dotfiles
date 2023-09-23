try %{
    require-module sort-selections
} catch %{
    source sort-selections.kak
    require-module sort-selections
}

define-command assert-buffer-content-is -params .. %{
    eval -draft %{
        exec '%H'
        eval %sh{
            if [ "$1" != "$kak_quoted_selections" ]; then
                printf 'fail "Check failed"\n'
            fi
        }
    }
}

edit -scratch *sort-selections-test-1*

# do a simple sort (and reverse sort) of 'foo' 'bar' 'baz'
exec ifoo<space>bar<space>baz<esc>
exec '%s\w+<ret>'
sort-selections
assert-buffer-content-is "'bar baz foo'"
sort-selections -reverse
assert-buffer-content-is "'foo baz bar'"
exec '%d'

# do a simple sort (and reverse sort) of '10' '30' '0' '100'
exec i10<space>30<space>0<space>100<esc>
exec '%s\w+<ret>'
sort-selections
assert-buffer-content-is "'0 10 30 100'"
sort-selections -reverse
assert-buffer-content-is "'100 30 10 0'"
exec '%d'

# do a sort based on the register content (which is the number we yanked previously)
exec ifoo2<space>bar3<space>baz1<esc>
exec -save-regs '' '%s\d<ret>y' # yank the number
exec '%s\w+<ret>' # select the entire words
sort-selections -register 'dquote'
assert-buffer-content-is "'baz1 foo2 bar3'"
# re-select: since we didn't change the dquote register, the sort-selections call is not idempotent
sort-selections -register 'dquote'
assert-buffer-content-is "'bar3 baz1 foo2'"
exec -save-regs '' '%s\d<ret>y' # re-yank the number
exec '%s\w+<ret>'
sort-selections -reverse -register 'dquote'
assert-buffer-content-is "'bar3 foo2 baz1'"
exec '%d'

exec ifoo<space>bar<space>baz<esc>
exec '%s\w+<ret>'
reverse-selections
assert-buffer-content-is "'baz bar foo'"
reverse-selections
assert-buffer-content-is "'foo bar baz'"
exec '%d'

delete-buffer
