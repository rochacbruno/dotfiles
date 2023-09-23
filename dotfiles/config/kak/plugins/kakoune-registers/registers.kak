define-command list-registers -docstring 'populate the *registers* buffer with the content of registers' %{
  # store special registers in z, save original value in option
  declare-option -hidden str-list z_reg %reg{z}
  set-register z "%% %reg{percent}" ". %reg{dot}" "# %reg{hash}"
  edit! -scratch *registers*
  evaluate-commands %sh{
    # empty scratch buffer
    echo 'execute-keys \%d'

    # paste the content of each register on a separate line
    # first the special registers, paste then add newlines
    echo "execute-keys '\"z<a-p>a<ret><esc>_'"
    # join multiline register contents
    echo "try %{ execute-keys 's\\\\n<ret>r<space>' }"
    echo "execute-keys 'geo<esc>'"

    # restore original z register
    echo 'set-register z %opt{z_reg}'

    # paste regular registers, also join multiline contents
    for reg in '"' '@' '/' '^' '|' \
               a b c d e f g h i j k l m n o p q r s t u v w x y z \
               0 1 2 3 4 5 6 8 9; do
      echo "execute-keys 'i${reg}<esc>\"${reg}pGj<a-j>o<esc>'"
    done

    # hide empty registers (lines with less than 4 chars)
    echo 'execute-keys \%<a-s><a-K>.{4,}<ret>d<space>'

    # make sure all registers are easily visible
    echo 'execute-keys gg'
  }
}

define-command info-registers -docstring 'populate an info box with the content of registers' %{
  list-registers
  try %{ execute-keys '%<a-s>s^.{30}\K[^\n]*<ret>c…<esc>' }
  execute-keys '%'
  declare-option -hidden str-list reg_info %val{selection}
  delete-buffer
  info -title registers -- %opt{reg_info}
}

