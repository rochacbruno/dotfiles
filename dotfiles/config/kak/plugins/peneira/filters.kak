provide-module peneira %{

require-module peneira-core

# This file defines some built-in filters

declare-option str peneira_files_command "fd --type file"

set-face global PeneiraFileName +b # used to highlight the file name on peneira-files

define-command peneira-files -params ..1 -docstring %{
    peneira-files: select a file in the current directory tree.
    Switches:
        -hide-opened Do not list already opened files.
} %{
    peneira-files-configure-buffer

    lua %arg{1} %val{buflist} %opt{peneira_files_command} %{
        local hide_opened = false

        if arg[1] == "-hide-opened" then
            hide_opened = true
            table.remove(arg, 1)
        end

        local command = table.remove(arg)

        if hide_opened then
            -- Do not list already opened files
            command = string.format("%s | grep -Fxv '%s'", command, table.concat(arg, "\n"))
        end

        kak.peneira("files: ", command, "edit %arg{1}")
    }
}

define-command -hidden peneira-files-configure-buffer %{
    hook -once global WinCreate "\*peneira%sh{ echo $kak_client | cut -c 7- }\*" %{
        add-highlighter window/ regex '([^/]+)$' 0:@PeneiraFileName
        add-highlighter window/ regex '/' 0:comment
        # We need to specify peneira-matches highlighter again to overwrite the
        # highlighter in the above line.
        add-highlighter window/peneira-matches ranges peneira_matches
    }
}

define-command peneira-local-files -docstring %{
    peneira-local-files: select a file in the directory tree of the current file, ignoring already opened ones.
} %{
    peneira-files-configure-buffer

    lua %val{buflist} %val{bufname} %opt{peneira_files_command} %{
        local command = table.remove(arg)
        local current_file = table.remove(arg)
        local local_dir = current_file:gsub("[^/]+$", "")

        -- Remove dir prefix from buffers names
        for i, buffer in ipairs(arg) do
            local _, last = buffer:find(local_dir, 1, true)

            if last then
                arg[i] = buffer:sub(last + 1)
            end
        end

        command = string.format([[
            current=$(pwd)
            cd %s
            # Do not list already opened files
            %s | grep -Fxv '%s'
            cd $current
        ]], local_dir, command, table.concat(arg, "\n"))

        kak.peneira("files: ", command, [[
            edit %sh{
                printf "%s/%s" $(dirname $kak_bufname) $1
            }
        ]])
    }
}

define-command peneira-symbols -docstring %{
    peneira-symbols: select a symbol definition for the current buffer
} %{
    peneira-symbols-configure-buffer

    peneira 'symbols: ' %{
        export LUA_PATH="$kak_opt_peneira_path/?.lua"
        $kak_opt_luar_interpreter "$kak_opt_peneira_path/filters.lua" symbols "$kak_buffile"
    } %{
        lua %arg{1} %val{buffile} %opt{peneira_path} %{
            addpackagepath(arg[3])
            local peneira = require "peneira"

            local selected, file = args()
            local index = tonumber(selected:match("%d+$"))
            local tags = peneira.read_tags(file)
            local tag = tags[index]

            kak.execute_keys(tag.line .. "gx")

            -- Interpret name literally
            local name = [[\Q]] .. tag.name .. [[\E]]

            -- Ctags may insert spaces in the name in some cases. For instance,
            -- if the tag name is `operator==`, ctags converts it to
            -- `operator ==`. In such cases, a search in the document for
            -- that name would fail. Thus, we need to make the spaces optional.
            name = name:gsub("%s", [[\E\s?\Q]])

            -- Kakoune interprets everything between angle brackets as
            -- a key (like <ret> and <esc>), so searching for thing like
            -- Vec<i64> won't work. Thus, we need to cheat a little.
            name = name:gsub("<", [[\E.\Q]])
            kak.execute_keys("s" .. name .. "<ret>vv")
        }
    }
}

define-command -hidden peneira-symbols-configure-buffer %{
    hook -once global WinCreate "\*peneira%sh{ echo $kak_client | cut -c 7- }\*" %{
        # tag kind (scope) index
        add-highlighter window/ regex '\S+ (\w+) (\([^)]+\)) (\d+)' 1:keyword 2:comment 3:+di@BufferPadding
        # tag kind : type index
        add-highlighter window/ regex '\S+ (\w+) : ([^\n]+) (\d+)' 1:keyword 2:type 3:+di@BufferPadding
        # tag kind : type (scope) index
        add-highlighter window/ regex '\S+ (\w+) : ([^\n]+) (\([^)]+\)) (\d+)' 1:keyword 2:type 3:comment 4:+di@BufferPadding
        # tag kind index
        add-highlighter window/ regex '\S+ (\w+) (\d+)' 1:keyword 2:+di@BufferPadding

        # We need to specify peneira-matches highlighter again to overwrite the
        # highlighter in the above line.
        add-highlighter window/peneira-matches ranges peneira_matches
    }
}

define-command peneira-lines -docstring %{
    peneira-lines: select a line in the current buffer
} %{
    evaluate-commands -save-regs '"fg' %{
        # Save filetype of current buffer to apply its highlighters to *peneira*
        # buffer.
        set-register f %opt{filetype}
        # Save current line to make *peneira* buffer also selects it.
        set-register g %val{cursor_line}
        peneira-lines-configure-buffer

        # Copy buffer contents to a temporary file.
        set-register dquote %sh{ mktemp }
        execute-keys -draft '%<a-|> cat > $kak_reg_dquote<ret>'

        peneira -no-rank 'lines: ' %{
            export LUA_PATH="$kak_opt_peneira_path/?.lua"
            $kak_opt_luar_interpreter "$kak_opt_peneira_path/filters.lua" lines $kak_reg_dquote
        } %{
            execute-keys %sh{ echo $1 | awk '{ print $1 }' }gx
        }

        nop %sh{ rm $kak_reg_dquote }
    }
}

define-command -hidden peneira-lines-configure-buffer %{
    hook -once global WinCreate "\*peneira%sh{ echo $kak_client | cut -c 7- }\*" %{
        lua %reg{f} %{
            local filetype = arg[1] == "kak" and "kakrc" or arg[1]
            kak.add_highlighter("window/", "ref", filetype)
        }

        add-highlighter window/ regex ^\s*\d+\s 0:@LineNumbers

        # The default face isn't that readable with the filetype highlighter
        # enabled.
        try %{
            set-face window PeneiraMatches default,default,rgb:ef2745+ub
        } catch %{
            set-face window PeneiraMatches default,rgba:34363e22+ib
        }

        # Start the filter with the current line selected.
        peneira-select-line %reg{g}
    }
}

try %{
    require-module mru-files

    define-command peneira-mru -docstring %{
        peneira-mru: select a file among the most recently used ones in the subtree of the current working directory.
    } %{
        peneira-files-configure-buffer

        peneira 'mru: ' %{
            grep "$(pwd)" $kak_config/mru_files.txt | sed -e "s!$(pwd)/!!"
        } %{
            edit %arg{1}
        }
    }
}

}

