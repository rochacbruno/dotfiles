define-command -hidden pasters %{
    set-register dquote %sh{
        echo "$kak_selections" | curl --data-binary @- https://paste.rs/
        }
        execute-keys ':echo Link in clipboard!<ret>'
}

define-command -hidden ixio %{
    set-register dquote %sh{
        echo "$kak_selections" | curl -F "f:1=<-" ix.io
        }
        execute-keys ':echo Link in clipboard!<ret>'
}

define-command -hidden dpaste %{
    set-register dquote %sh{
        echo "$kak_selections" | curl -F "format=url" -F "content=<-" https://dpaste.org/api/
        }
        execute-keys ':echo Link in clipboard!<ret>'
}

define-command -hidden dpastemozilla %{
    set-register dquote %sh{
        echo "$kak_selections" | curl -F "format=url" -F "content=<-" https://paste.mozilla.org/api/
        }
        execute-keys ':echo Link in clipboard!<ret>'
}

declare-user-mode pastebin

map global pastebin i ': ixio<ret>'                             -docstring 'ix.io'
map global pastebin p ': pasters<ret>'                          -docstring 'paste.rs'
map global pastebin d ': dpaste<ret>'                           -docstring 'dpaste.org'
map global pastebin m ': dpastemozilla<ret>'                    -docstring 'paste.mozilla.org'

# trick to access count, 3b → display third buffer
define-command enter-pastebin-mode %{
    evaluate-commands %sh{
        printf 'enter-user-mode pastebin'
    }
}
