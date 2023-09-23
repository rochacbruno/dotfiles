hook global ModuleLoaded peneira-filters %{
    map global peneira-filters -docstring "grep file contents recursively" 'g' '<esc>: require-module peneira-grep<ret><esc>:peneira-grep '
}

provide-module peneira-grep %§
    
define-command peneira-grep -params 1 %{
    peneira -no-rank 'line: ' "rg --hidden --glob='!.git' --column %arg{1}" %{
        lua %arg{1} %{
            local file, line, column = arg[1]:match("([^:]+):(%d+):(%d+):")
            kak.edit(file, line, column)
        }
    }
}

§
