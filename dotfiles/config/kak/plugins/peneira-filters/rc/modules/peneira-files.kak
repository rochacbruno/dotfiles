hook global ModuleLoaded peneira-filters %{
    map global peneira-filters -docstring "list files" 'f' '<esc>: require-module peneira; peneira-files<ret>'
}

