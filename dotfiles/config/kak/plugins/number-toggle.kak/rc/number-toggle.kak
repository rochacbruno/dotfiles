provide-module number-toggle %{

declare-option -docstring 'Line number highlighter parameters' str-list number_toggle_params

declare-option -hidden str number_toggle_internal_state '-relative'

define-command -hidden number-toggle-refresh %{ evaluate-commands %sh{
  printf '%s' "add-highlighter -override window/number-toggle number-lines $kak_quoted_opt_number_toggle_params $kak_opt_number_toggle_internal_state"
}}

define-command -hidden number-toggle-install-focus-hooks %{
  hook -group number-toggle-focus window FocusOut .* %{
    set-option window number_toggle_internal_state ''
    number-toggle-refresh
  }
  hook -group number-toggle-focus window FocusIn .* %{
    set-option window number_toggle_internal_state '-relative'
    number-toggle-refresh
  }
}

define-command -hidden number-toggle-uninstall-focus-hooks %{
  remove-hooks window number-toggle-focus
}

# Display relative line numbers when starting Kakoune in normal mode
hook -always global WinCreate .* %{
  set-option window number_toggle_internal_state '-relative'
  number-toggle-refresh
  number-toggle-install-focus-hooks

  # Display absolute line numbers when entering insert mode
  hook -always window ModeChange push:.*:insert %{
    set-option window number_toggle_internal_state ''
    number-toggle-refresh
    number-toggle-uninstall-focus-hooks
  }

  # Display relative line numbers when leaving insert mode
  hook -always window ModeChange pop:insert:.* %{
    set-option window number_toggle_internal_state '-relative'
    number-toggle-refresh
    number-toggle-install-focus-hooks
  }
}

}
