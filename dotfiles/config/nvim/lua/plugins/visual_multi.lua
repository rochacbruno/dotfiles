return {
  -- Multicursor (ctrl up/down, ctrl-N)
  -- Ctrl Mouse Click
  -- \\ = leader
  -- \\\ = add cursor at position
  -- \\-A = Select all cwords in the file and create a cursor for it
  -- \\-/ = regex search adding cursor for matches
  -- \\-\ = cursor at position
  -- C-N + S-S" (add surround)
  -- C-Up-Down + \\-< + (char)  = align
  -- C-Up-Down + \\-0n (\\-N or \\-n) = Append numbers starting on 0
  -- select `sep`(:) - C-N - (multi cursor on all) -
  --                  \\-a (align)
  --                  \\-d (duplicate)
  --                  \\-C (case conversion)
  -- C-Down - f: (find `:`) - \\a (align)
  -- \\-` = tools menu
  -- C-N - mii - c (select, match inner function, change)
  "mg979/vim-visual-multi",
}
