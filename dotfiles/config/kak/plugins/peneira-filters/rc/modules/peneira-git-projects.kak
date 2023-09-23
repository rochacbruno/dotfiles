hook global ModuleLoaded peneira-filters %{
    map global peneira-filters -docstring "List all folders in $HOME which is under git version control" 'p' '<esc>: require-module peneira-git-projects; peneira-git-projects<ret>'
}

provide-module peneira-git-projects %§

# TODO introduce var to define projects dir, e.g. ~/src
define-command peneira-git-projects %{
    peneira 'git: ' "fd --type d --hidden '^.git$' $HOME | sed 's/.git\///'" %{
        change-directory %arg{1}
    }
}

§
