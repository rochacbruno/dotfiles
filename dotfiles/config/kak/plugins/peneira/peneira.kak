declare-option -hidden str peneira_path %sh{ dirname $kak_source }

provide-module peneira-core %◍

require-module luar

declare-option -hidden int peneira_selected_line 1 # used to track the selected line
declare-option -hidden line-specs peneira_flag # used to flag selected line
declare-option -hidden range-specs peneira_matches # used to highlight matches
declare-option -hidden str peneira_previous_prompt # used to track changes in prompt
declare-option -hidden str peneira_temp_file # name of the temp file in sync with buffer contents
declare-option -hidden str-list peneira_buffer_history # track the last visited buffers

set-face global PeneiraSelected default,rgba:1c1d2122
set-face global PeneiraFlag LineNumberCursor
set-face global PeneiraMatches value

define-command peneira -params 3..4 -docstring %{
    peneira [<switches>] <prompt> <candidates> <cmd>: filter candidates provided by <candidates> shell command and then run <cmd> with %arg{1} set to the selected candidate.
    Switches:
        -no-rank  do not rank candidates (respect their ordering).
} %{
    # Hack to avoid messing up with `ga` keys
    peneira-save-last-visited-buffer

    lua %arg{@} %{
        local rank = true

        for i, a in ipairs(arg) do
            if a == "-no-rank" then
                rank = false
                table.remove(arg, i)
                break
            end
        end

        unpack = unpack or table.unpack -- make it compatible with both lua and luajit
        kak.peneira_finder(rank, unpack(arg))
    }
}

# peneira-finder will do the following:
#
#   * create a temporary file to store candidates;
#   * execute (in the user context, so that shell expansions work as expected)
#     the shell command that generates candidates (3rd argument) and write the
#     output to the temporary file;
#   * create a disposable *peneira* buffer to present the candidates to the
#     user;
#   * show a prompt to collect user input and filter candidates accordingly;
#   * execute kak commands (4th argument) after the user has selected a
#     candidate.
#   * delete the disposable buffer and remove the temporary file.
#
# arg1: whether to rank candidates
# arg2: text for prompt
# arg3: command to generate candidates
# arg4: command to execute after selecting candidate
define-command -hidden peneira-finder -params 4 %{
    evaluate-commands -save-regs p %{
        lua %arg{3} %{
            local command = arg[1]:gsub([["]],[[\"]])
            -- %arg{3} (the command that generates candidates) may contain
            -- shell expansions. If we use it directly inside %sh{}, Kakoune
            -- doesn't interpret those expansions. E.g., say %arg{3} contains
            -- `cat $kak_buffile`. If we do something like
            --
            --     set-register p %sh{
            --         ...
            --         eval "$2" > $file
            --         ...
            --     }
            -- 
            -- Kakoune will se only that `$2` expansion, but not the
            -- `$kak_buffile` *inside* `$2` and thus `$kak_buffile` won't
            -- be set.
            --
            -- That's why we need to inject the contents of %arg{3} manually
            -- before executing set-register.
            print(string.format([[
                set-register p %%sh{
                    # Execute command that generates candidates, and populate temp file
                    file=$(mktemp)
                    eval "%s" > $file
                    # Write file name to register p
                    printf "%%s" $file
                }
            ]], command))
        }

        edit -scratch "*peneira%sh{ echo $kak_client | cut -c 7- }*"
        set-option buffer peneira_temp_file %reg{p}
    }

    peneira-fill-buffer
    peneira-configure-buffer

    prompt -on-change %{
        peneira-filter-buffer %arg{1} "%val{text}"

        # Save current prompt contents to be compared against the prompt of the
        # next iteration
        set-option buffer peneira_previous_prompt "%val{text}"
        peneira-select-line %opt{peneira_selected_line}

        # It may happen that, filtering out some candidates, the line marked as
        # selected overflows the buffer.
        peneira-avoid-buffer-overflow

    } %arg{2} %{
        evaluate-commands -save-regs xz %{
            try %{
                # Copy selected line to register x
                execute-keys %opt{peneira_selected_line}gx_\"xy

                # Now, delete *peneira* buffer to call %arg{4} in the context of the
                # original buffer
                peneira-clear-environment

                # Copy <cmd> to register z (peneira-call expects <cmd> to be in
                # register z)
                set-register z "%arg{4}"

                try %{
                    peneira-call "%reg{x}"

                } catch %{
                    # Kakoune doesn't write errors raised in the prompt to the
                    # *debug* buffer. So we need to do it manually.
                    echo -debug "Error: 'peneira' %val{error}"
                    fail "peneira: error executing filter, check *debug* buffer"
                }
            } catch %{
                peneira-clear-environment
            }
        }

    } -on-abort peneira-clear-environment
}

# We are about to save the name of the last visited buffer. This way, after the
# `peneira` command runs, we can visit that buffer again to be able to go back
# to it with `ga` if we want to.
# 
# This is an ugly hack, but loosing `ga` keys is very annoying. Suggestions to
# do it in a cleaner way are welcoming.
define-command -hidden peneira-save-last-visited-buffer %{
    evaluate-commands -save-regs b %{
        try %{
            execute-keys ga
            set-register b %val{bufname}
            execute-keys ga
            set-option buffer peneira_buffer_history %reg{b} %val{bufname}
        }
    }
}

# After running `peneira`, we can now visit the last buffer again to restore the
# behaviour of `ga`.
define-command -hidden peneira-restore-last-visited-buffer %{
    lua %opt{peneira_buffer_history} %{
        for _, buffer in ipairs(arg) do
            kak.buffer(buffer)
        end
    }
}

define-command -hidden peneira-fill-buffer %{
    # Populate *peneira* buffer with the contents of the temp file
    execute-keys "%%| cat %opt{peneira_temp_file}<ret>"
        peneira-select-line %opt{peneira_selected_line}
    set-option buffer peneira_matches
}

# Configure highlighters and mappings
define-command -hidden peneira-configure-buffer %{
    remove-highlighter window/number-lines
    add-highlighter buffer/peneira-matches ranges peneira_matches
    add-highlighter buffer/peneira-flag flag-lines @PeneiraFlag peneira_flag
    face window PrimaryCursor @PeneiraSelected

    map buffer prompt <down> "<a-;>: peneira-select-next-line<ret>"
    map buffer prompt <tab> "<a-;>: peneira-select-next-line<ret>"
    map buffer prompt <c-n> "<a-;>: peneira-select-next-line<ret>"
    map buffer prompt <up> "<a-;>: peneira-select-previous-line<ret>"
    map buffer prompt <s-tab> "<a-;>: peneira-select-previous-line<ret>"
    map buffer prompt <c-p> "<a-;>: peneira-select-previous-line<ret>"
}

define-command -hidden peneira-select-line -params 1 %{
    execute-keys "<a-;>%arg{1}g"
    set-option buffer peneira_flag %val{timestamp} "%arg{1}| ❯ "
    set-option buffer peneira_selected_line %arg{1}
    add-highlighter -override buffer/current-line line %arg{1} PeneiraSelected
}

define-command -hidden peneira-select-previous-line %{
    lua %opt{peneira_selected_line} %val{buf_line_count} %{
        local selected, line_count = args()
        selected = selected > 1 and selected - 1 or line_count
        kak.peneira_select_line(selected)
    }
}

define-command -hidden peneira-select-next-line %{
    lua %opt{peneira_selected_line} %val{buf_line_count} %{
        local selected, line_count = args()
        selected = selected % line_count + 1
        kak.peneira_select_line(selected)
    }
}

define-command -hidden peneira-avoid-buffer-overflow %{
    lua %opt{peneira_selected_line} %val{buf_line_count} %{
        local selected, line_count = args()

        if selected > line_count then
            kak.peneira_select_line(line_count)
        end
    }
}

# The actual filtering happens here.
# arg1: whether to rank candidates
# arg2: prompt text
define-command -hidden peneira-filter-buffer -params 2 %{
    evaluate-commands -buffer "*peneira%sh{ echo $kak_client | cut -c 7- }*" -save-regs p %{
        lua %opt{peneira_path} %opt{peneira_temp_file} %opt{peneira_previous_prompt} %arg{@} %{
            local peneira_path, filename, previous_prompt, rank, prompt = args()

            if prompt == previous_prompt then
                return
            end

            prompt = "" .. prompt -- force it to be a string, since it may be a number

            if #prompt == 0 then
                kak.peneira_fill_buffer()
                return
            end

            -- Add plugin path to the list of path to be searched by `require`
            addpackagepath(peneira_path)
            local peneira = require "peneira"

            local lines, positions, best_match = peneira.filter(filename, prompt, rank)

            if not lines then
                kak.execute_keys("%d")
                return
            end

            kak.set_register("p", table.concat(lines, "\n"))
            kak.execute_keys('%"pR')

            if not rank then
                -- With no rank of lines, it's less likely that the selected
                -- line is the desired one. To increase the likelyhood of
                -- a best match, we automatically select the line with the
                -- highest score.
                kak.peneira_select_line(best_match)
            end

            local range_specs = peneira.range_specs(positions)
            if #range_specs == 0 then return end

            unpack = unpack or table.unpack -- make it compatible with both lua and luajit
            kak.peneira_highlight_matches(unpack(range_specs))
        }
    }
}

# args: range specs
define-command -hidden peneira-highlight-matches -params 1.. %{
    lua %arg{@} %val{timestamp} %{
        local timestamp = table.remove(arg)
        unpack = unpack or table.unpack
        kak.set_option("buffer", "peneira_matches", timestamp, unpack(arg))
    }
}

define-command -hidden peneira-clear-environment %{
    nop %sh{ rm $kak_opt_peneira_temp_file }
    delete-buffer "*peneira%sh{ echo $kak_client | cut -c 7- }*"
    peneira-restore-last-visited-buffer
}

# When the user selects some candidate, we want that the provided commands block
# see the selected line as the %arg{1} expansion. To do so, we pass the selected
# line as the sole argument of peneira-call. This way, whathever we execute
# inside peneira-call will have access to this %arg{1} expansion.
define-command -hidden peneira-call -params 1 %{
    evaluate-commands "%reg{z}"
}

require-module kak
require-module sh

add-highlighter shared/kakrc/code/peneira regex (?:\s|\A)\K(peneira|peneira-files|peneira-local-files|peneira-lines|peneira-symbols)(?:(?=\s)|\z) 0:keyword
add-highlighter shared/kakrc/peneira1 region -recurse '\{' '(^|\h)peneira(?: -no-rank)? "[^"]+" %\{\K' '\}' ref sh
add-highlighter shared/kakrc/peneira2 region -recurse '\{' '(^|\h)peneira(?: -no-rank)? ''[^'']+'' %\{\K' '\}' ref sh
add-highlighter shared/kakrc/peneira3 region -recurse '\(' '(^|\h)peneira(?: -no-rank)? "[^"]+" %\(\K' '\)' ref sh
add-highlighter shared/kakrc/peneira4 region -recurse '\(' '(^|\h)peneira(?: -no-rank)? ''[^'']+'' %\(\K' '\)' ref sh
add-highlighter shared/kakrc/peneira5 region -recurse '\[' '(^|\h)peneira(?: -no-rank)? "[^"]+" %\[\K' '\]' ref sh
add-highlighter shared/kakrc/peneira6 region -recurse '\[' '(^|\h)peneira(?: -no-rank)? ''[^'']+'' %\[\K' '\]' ref sh
add-highlighter shared/kakrc/peneira7 region -recurse '<' '(^|\h)peneira(?: -no-rank)? "[^"]+" %<\K' '>' ref sh
add-highlighter shared/kakrc/peneira8 region -recurse '<' '(^|\h)peneira(?: -no-rank)? ''[^'']+'' %<\K' '>' ref sh

◍
