local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
--
--

autocmd({"BufEnter"}, {
  pattern = "*",
  command = "setlocal nospell"
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

-- TRIM whitespace on specified patterns when saving.
local trim_group = augroup("Trim", {})
autocmd({ "BufWritePre" }, {
  group = trim_group,
  pattern = {
    "*.py",
    "*.rs",
    "*.toml",
    "*.yaml",
    "*.txt",
    "*.in",
    "*.lua",
    "*.json",
    "*.i3config",
    "*.conf",
  },
  command = [[%s/\s\+$//e]],
})

local yank_group = augroup('HighlightYank', {})
autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 2000,
    })
  end,
})

-- local customtheme_group = augroup("CustomTheme", {})
-- autocmd({ "BufWinEnter" }, {
--   group = customtheme_group,
--   pattern = "*",
--   command = "colorscheme catppuccin-mocha",
-- })
-- autocmd({ "BufWinEnter" }, {
--   group = customtheme_group,
--   pattern = {"markdown"},
--   command = "echo 'aaaaa'",
-- })
-- autocmd({ "BufWinEnter" }, {
--   group = customtheme_group,
--   pattern = "markdown",
--   command = "colorscheme catppuccin-latte",
-- })

-- autocmd('RecordingEnter',
--   callback = function()
--       require("noice")
--   end,
-- )

-- MORE EXAMPLES
-- local aucmd_dict = {
--     FileType = {
--         {
--             pattern = "markdown,txt",
--             callback = function()
--                 vim.api.nvim_win_set_option(0, "spell", true)
--             end,
--         },
--         {
--             pattern = "help,lspinfo,qf,startuptime",
--             callback = function()
--                 vim.api.nvim_set_keymap(
--                     "n",
--                     "q",
--                     "<cmd>close<CR>",
--                     { noremap = true, silent = true }
--                 )
--             end,
--         },
--     },
-- }

-- for event, opt_tbls in pairs(aucmd_dict) do
--     for _, opt_tbl in pairs(opt_tbls) do
--         vim.api.nvim_create_autocmd(event, opt_tbl)
--     end
-- end
