-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd({ "BufEnter" }, {
  pattern = "*",
  command = "setlocal nospell",
})

-- Set .i3config as extension for i3 files
local i3_group = augroup("I3Wm", {})
autocmd({ "BufEnter" }, {
  group = i3_group,
  pattern = { "*.i3config" },
  command = "setlocal filetype=i3config",
})

-- NNUmber mode toggling
-- Relative numbers shows on: N, V, *, Focus
-- Normal numbets shows on: I, out focus
local number_group = augroup("Number", {})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = number_group,
  pattern = { "*" },
  command = "if &nu | setlocal norelativenumber | endif",
})
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = number_group,
  pattern = { "*" },
  command = [[if &nu && mode() != "i" | setlocal relativenumber | endif]],
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "run-code-output",
  command = "set ft=json",
})

-- Get out of insert on focuslost
local focus_group = augroup("Focus", {})
autocmd({ "FocusLost" }, {
  group = focus_group,
  pattern = { "*" },
  command = "if mode() == 'i' | stopinsert | endif",
  -- alternative: | call feedkeys("\<C-\>\<C-n>") |
})

-- TRIM whitespace on specified patterns when saving.
-- local trim_group = augroup("Trim", {})
-- autocmd({ "BufWritePre" }, {
--   group = trim_group,
--   pattern = {
--     "*.py",
--     "*.rs",
--     "*.toml",
--     "*.yaml",
--     "*.txt",
--     "*.in",
--     "*.lua",
--     "*.json",
--     "*.i3config",
--     "*.conf",
--     "*.css",
--     "*.html"
--   },
--   -- command = [[%s/\s\+$//e]],
--   callback = function()
--     -- Save cursor position to later restore
--     local curpos = vim.api.nvim_win_get_cursor(0)
--     -- Search and replace trailing whitespace
--     vim.cmd([[keeppatterns %s/\s\+$//e]])
--     vim.api.nvim_win_set_cursor(0, curpos)
--     -- Clean up last empty lines
--     local n_lines = vim.api.nvim_buf_line_count(0)
--     local last_nonblank = vim.fn.prevnonblank(n_lines)
--     if last_nonblank < n_lines then vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, {}) end
--   end,
-- })

-- local yank_group = augroup("lazyvim_highlight_yank", {})
autocmd("TextYankPost", {
  -- group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      -- higroup = "IncSearch",
      timeout = 2000,
    })
  end,
})
