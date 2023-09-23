hook global ModuleLoaded peneira-filters %{
    map global peneira-filters -docstring "Lists lines in the current file to go to a specific line in your document." 'l' '<esc>: require-module peneira; peneira-lines<ret>'
}

