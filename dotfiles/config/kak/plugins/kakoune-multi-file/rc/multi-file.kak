decl -hidden str multi_file_home %sh{ dirname $(dirname "$kak_source") }

# Commands

def -params .. \
    -override \
    -docstring 'Create multi-file file from grep results' \
    multi-file-from-grep \
%{
    require-module multi-file-colors
    eval %sh{
        # Setup fifos
        work_dir=$(mktemp -d "${TMPDIR:-/tmp}"/kak.XXXXXXXX)
        mkdir -p "$work_dir"
        mkfifo "$work_dir/input"
        mkfifo "$work_dir/output"

        # Spawn script
        (
            "$kak_opt_multi_file_home/scripts/multi_file_from_grep.py" $@ \
                <"$work_dir/input" \
                >"$work_dir/output"
        ) >/dev/null 2>&1 </dev/null &

        # Read output to client, write input
        printf %s "
            eval %{
                edit! -fifo '$work_dir/output' *multi-file*
                set buffer filetype multi-file
                hook -always -once buffer BufCloseFifo .* %{
                    nop %sh{ rm -r '$work_dir' }
                    exec -draft gjd
                    multi-file-close-empty '$kak_client'
                }
            }
            eval -buffer '$kak_bufname' %{
                write '$work_dir/input'
            }
        "
    }
}

def -override \
    -docstring 'Apply and close multi-file' \
    multi-file-apply \
%{
    multi-file-ensure-buffer-exists

    eval %sh{
        # Setup fifos
        work_dir=$(mktemp -d "${TMPDIR:-/tmp}"/kak.XXXXXXXX)
        mkdir -p "$work_dir"
        mkfifo "$work_dir/input"
        mkfifo "$work_dir/output"

        # Spawn script, close buffers on success
        (
            "$kak_opt_multi_file_home/scripts/apply_multi_edit.py" \
                <"$work_dir/input" \
                >"$work_dir/output" 2>&1

            if [ $? = 0 ]; then
                printf %s "
                    try %{ db *multi-file* }
                    try %{ db *multi-file-output* }
                    try %{ db *multi-file-review* }
                    eval -client '$kak_client' %{
                        echo -markup {Information}All changes applied
                    }
                " | kak -p "$kak_session"
            else
                printf %s "
                    eval -client '$kak_client' %{
                        echo -markup {Error}Not all changes were applied
                    }
                " | kak -p "$kak_session"
            fi
        ) >/dev/null 2>&1 </dev/null &

        # Read output to client, write input
        printf %s "
            eval -try-client '$kak_opt_toolsclient' %{
                edit! -fifo '$work_dir/output' *multi-file-output*
                hook -always -once buffer BufCloseFifo .* %{
                    nop %sh{ rm -r '$work_dir' }
                }
            }
            eval -buffer *multi-file* %{
                write '$work_dir/input'
            }
        "
    }
}

def -override \
    -docstring 'Review changes in multi-file' \
    multi-file-review \
%{
    multi-file-ensure-buffer-exists

    eval %sh{
        # Setup fifos
        work_dir=$(mktemp -d "${TMPDIR:-/tmp}"/kak.XXXXXXXX)
        mkdir -p "$work_dir"
        mkfifo "$work_dir/input"
        mkfifo "$work_dir/output"

        # Spawn script, close buffers on success
        (
            "$kak_opt_multi_file_home/scripts/apply_multi_edit.py" --dry-run \
                <"$work_dir/input" \
                >"$work_dir/output" 2>&1

            if [ $? = 0 ]; then
                printf %s "
                    eval -client '$kak_client' %{
                        echo -markup {Information}All changes can be applied
                    }
                " | kak -p "$kak_session"
            else
                printf %s "
                    eval -client '$kak_client' %{
                        echo -markup {Error}Not all changes can be applied
                    }
                " | kak -p "$kak_session"
            fi
        ) >/dev/null 2>&1 </dev/null &

        # Read output to client, write input
        printf %s "
            eval -try-client '$kak_opt_toolsclient' %{
                edit! -fifo '$work_dir/output' *multi-file-review*
                set buffer filetype diff
                hook -always -once buffer BufCloseFifo .* %{
                    nop %sh{ rm -r '$work_dir' }
                }
            }
            eval -buffer *multi-file* %{
                write '$work_dir/input'
            }
        "
    }
}

# Utility commands

def -hidden \
    -override \
    -params 1 \
    multi-file-close-empty \
%{
    try %{
        exec -draft <%> s (?S). <ret>
    } catch %{
        db
        eval -client %arg{1} %{
            echo -markup {Error}No grep lines detected
        }
    }
}

def -hidden \
    -override \
    multi-file-ensure-buffer-exists \
%{
    try %{
        eval -buffer *multi-file* ''
    } catch %{
        fail 'No *multi-file* buffer'
    }
}

# Colors

provide-module multi-file-colors %§

    try %{ rmhl shared/multi-file }
    try %{ rmhooks global multi-file-highlight }

    addhl shared/multi-file regions

    addhl shared/multi-file/default default-region \
        regex "^@@@[^\n]*@@@$" 0:Information

    def -hidden \
        -params 2 \
        -override \
        multi-file-hl-lang \
    %{
        eval %sh{
            printf '
                addhl shared/multi-file/%s region \
                    "(?Si)^@@@ .*%s \d+,\d+ \S+ \S+ @@@$" \
                    "^(?=@@@ )" \
                    regions
            ' "$1" "$2"

            printf '
                addhl shared/multi-file/%s/header region \
                    "(?S)^@@@.*@@@$" $ \
                    fill Information
            ' "$1"

            printf '
                addhl shared/multi-file/%s/body default-region \
                    ref %s
            ' "$1" "$1"
        }
    }

    multi-file-hl-lang objc \.(c|cc|cl|cpp|h|hh|hpp|m|mm)
    multi-file-hl-lang cabal \.cabal
    multi-file-hl-lang clojure \.(clj|cljc|cljs|cljx|edn)
    multi-file-hl-lang coffee \.coffee
    multi-file-hl-lang css .*\.css
    multi-file-hl-lang d .*\.d
    multi-file-hl-lang dockerfile dockerfile
    multi-file-hl-lang fish \.fish
    multi-file-hl-lang go \.go
    multi-file-hl-lang haskell \.hs
    multi-file-hl-lang html \.html?
    multi-file-hl-lang ini \.ini
    multi-file-hl-lang java \.java
    multi-file-hl-lang typescript \.m?[jt]sx?
    multi-file-hl-lang json \.json
    multi-file-hl-lang julia \.jl
    multi-file-hl-lang kakrc (\.kak|kakrc)
    multi-file-hl-lang latex \.(tex|cls|sty|dtx)
    multi-file-hl-lang lua \.lua
    multi-file-hl-lang makefile (makefile|\.mk|\.make)
    multi-file-hl-lang markdown \.(markdown|md|mkd)
    multi-file-hl-lang perl \.(t|p[lm])
    multi-file-hl-lang python \.py
    multi-file-hl-lang ruby \.rb
    multi-file-hl-lang rust \.rs
    multi-file-hl-lang sass \.sass
    multi-file-hl-lang scala \.scala
    multi-file-hl-lang scss \.scss
    multi-file-hl-lang sh \.(z|ba|c|k|mk)?sh(rc|_profile)?
    multi-file-hl-lang swift \.swift
    multi-file-hl-lang toml \.toml
    multi-file-hl-lang yaml \.ya?ml
    multi-file-hl-lang sql \.sql

    hook -group multi-file-highlight global WinSetOption filetype=multi-file %{
        addhl window/multi-file ref multi-file
        hook -once -always window WinSetOption filetype=.* %{
            rmhl window/multi-file
        }
    }

§ # module multi-file-colors
