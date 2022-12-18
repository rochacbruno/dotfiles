
local picker = require('window-picker')

vim.keymap.set("n", ",w", function()
  local picked_window_id = picker.pick_window({
    include_current_win = true
  }) or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, { desc = "Pick a window" })

-- Swap two windows using the awesome window picker
-- FIX: This function is not working
vim.keymap.set("n", ",e", function()
  local other_window = picker.pick_window({
    include_current_win = false
  })
  local target_buffer = vim.fn.winbufnr(other_window)
  vim.api.nvim_win_set_buf(other_window, 0)
  vim.api.nvim_win_set_buf(0, target_buffer)
end, { desc = "Swap windows" })

