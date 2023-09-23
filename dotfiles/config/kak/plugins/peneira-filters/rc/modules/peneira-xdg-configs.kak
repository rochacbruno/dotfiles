hook global ModuleLoaded peneira-filters %{
    map global peneira-filters -docstring "List all files under your $XDG_CONFIG_HOME" 'c' '<esc>: require-module peneira-xdg-configs; peneira-xdg-configs<ret>'
}

provide-module peneira-xdg-configs %§

define-command peneira-xdg-configs %{
    peneira 'configs: ' "fd --type f --hidden -L '' $XDG_CONFIG_HOME" %{
        edit %arg{1}
    }
}

§
