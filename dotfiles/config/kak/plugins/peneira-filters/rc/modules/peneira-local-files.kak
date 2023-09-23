hook global ModuleLoaded peneira-filters %{
    map global peneira-filters -docstring "list files from the directory of the currentlyedited file" 'F' '<esc>: require-module peneira; peneira-local-files<ret>'
}

