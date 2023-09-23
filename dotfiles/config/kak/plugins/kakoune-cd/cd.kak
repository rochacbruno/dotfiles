define-command change-directory-current-buffer -docstring 'cd to current buffer dir' %{
  evaluate-commands %sh{
    buffer_dirname=$(dirname "$kak_bufname")
    echo "cd \"${buffer_dirname}\""
    echo print-working-directory
  }
}

# only works for git now, use `hg root` for mercurial
define-command change-directory-project-root -docstring 'cd to project root dir' %{
  change-directory-current-buffer
  evaluate-commands %sh{
    project_root=$(git rev-parse --show-toplevel)
    echo "cd \"${project_root}\""
    echo print-working-directory
  }
}

define-command print-working-directory -docstring 'print working directory' %{
  evaluate-commands %sh{
    echo "echo -markup {Information}$PWD"
  }
}

declare-option -hidden str oldpwd

define-command edit-current-buffer-directory -docstring 'edit in current buffer dir' %{
  evaluate-commands %sh{ echo "set global oldpwd '$PWD'" }
  change-directory-current-buffer
  execute-keys :edit<space>
  hook -group oldpwd global BufCreate .* %{
    change-directory "%opt{oldpwd}"
    remove-hooks global oldpwd
  }
  # on cancelled edit prompt
  hook -group oldpwd global RawKey <esc> %{
    change-directory "%opt{oldpwd}"
    remove-hooks global oldpwd
  }
}

declare-user-mode cd
map global cd b '<esc>: change-directory-current-buffer<ret>' -docstring 'current buffer dir'
map global cd c '<esc>: cd %val{config}; print-working-directory<ret>' -docstring 'config dir'
map global cd e '<esc>: edit-current-buffer-directory<ret>' -docstring 'edit in current buffer dir'
map global cd h '<esc>: cd; print-working-directory<ret>' -docstring 'home dir'
map global cd p '<esc>: cd ..; print-working-directory<ret>' -docstring 'parent dir'
map global cd r '<esc>: change-directory-project-root<ret>' -docstring 'project root dir'

# Suggested aliases

#alias global cdb change-directory-current-buffer
#alias global cdr change-directory-project-root
#alias global ecd edit-current-buffer-directory
#alias global pwd print-working-directory
