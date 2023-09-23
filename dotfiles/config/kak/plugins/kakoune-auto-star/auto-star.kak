define-command -hidden auto-star -params 1 %{
  try %{
    exec %val{count}%arg{1}
  } catch %{
    exec -save-regs '' *
    exec %val{count}%arg{1}
  }
}

map global normal n ':auto-star n<ret>'            -docstring 'auto-star n'
map global normal N ':auto-star N<ret>'            -docstring 'auto-star N'
map global normal <a-n> ':auto-star <lt>a-n><ret>' -docstring 'auto-star <a-n>'
map global normal <a-N> ':auto-star <lt>a-N><ret>' -docstring 'auto-star <a-N>'

