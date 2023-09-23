hook global ModuleLoaded peneira-filters %{
    map global peneira-filters -docstring "list buffers" 'b' '<esc>: require-module peneira-buffers; peneira-buffers<ret>'
}

provide-module peneira-buffers %§
    
define-command peneira-buffers %{
    peneira 'buffers: ' %{ printf '%s\n' $kak_quoted_buflist } %{
        buffer %arg{1}
    }
}

§
