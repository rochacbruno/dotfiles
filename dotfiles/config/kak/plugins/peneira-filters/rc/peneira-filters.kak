require-module peneira

define-command -docstring "Enter peneira-filters-mode.
peneira-filters-mode contains mnemonic key bindings for every peneira-filters.kak command

Best used with mapping like:
    map global normal '<some key>' ': peneira-filters-mode<ret>'
" \
peneira-filters-mode %{ require-module peneira-filters; evaluate-commands 'enter-user-mode peneira-filters' }

provide-module peneira-filters %§

try %{ declare-user-mode peneira-filters }

§

