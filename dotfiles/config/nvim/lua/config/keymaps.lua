-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps her
-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- save
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>update<cr><esc>", { desc = "Save file" })
-- easy escape
map({ "i" }, "jk", "<esc>", { desc = "jk to escape" })
-- rest nvim
map({ "n" }, "<leader>xr", "<cmd>lua require'rest-nvim'.run(false)<cr>", { desc = "Rest Run" })
map({ "n" }, "<leader>xr", "<cmd>lua require'rest-nvim'.run(true)<cr>", { desc = "Rest Preview" })
map({ "n" }, "<leader>xr", "<cmd>lua require'rest-nvim'.last()<cr>", { desc = "Rest last request" })
map({ "n" }, "<leader>xr", "<cmd>lua require('user.functions').open_rest_nvim_file()<cr>", { desc = "Open Rest File" })

-- tree
map({ "i", "n", "v", "s" }, "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Focus Neotree" })

-- spectre find and replace
map({ "i", "n", "v", "s" }, "<leader>srr", "<cmd>lua require'spectre'.open()<cr>", { desc = "Replace in Files" })
map(
  { "i", "n", "v", "s" },
  "<leader>srw",
  "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
  { desc = "Replace in Word" }
)
map(
  { "i", "n", "v", "s" },
  "<leader>srf",
  "<cmd>lua require('spectre').open_file_search()<cr>",
  { desc = "Replace in Buffer" }
)
map(
  { "i", "n", "v", "s" },
  "<leader>srs",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace Cursor Word" }
)

-- telescope
map({ "i", "n", "v", "s" }, "<leader>tb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
map({ "i", "n", "v", "s" }, "<leader>tc", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme" })
map({ "i", "n", "v", "s" }, "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "Files" })
map({ "i", "n", "v", "s" }, "<leader>td", "<cmd>Telescope fd<cr>", { desc = "Files Preview" })
map({ "i", "n", "v", "s" }, "<leader>tt", "<cmd>Telescope live_grep<cr>", { desc = "Text Grep" })
map({ "i", "n", "v", "s" }, "<leader>ts", "<cmd>Telescope grep_string<cr>", { desc = "String Grep" })
map({ "i", "n", "v", "s" }, "<leader>th", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
map({ "i", "n", "v", "s" }, "<leader>tH", "<cmd>Telescope highlights<cr>", { desc = "Highlights" })
map(
  { "i", "n", "v", "s" },
  "<leader>ti",
  "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>",
  { desc = "Media" }
)
map({ "i", "n", "v", "s" }, "<leader>tr", "<cmd>Telescope resume<cr>", { desc = "Last Action" })
map({ "i", "n", "v", "s" }, "<leader>to", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
map({ "i", "n", "v", "s" }, "<leader>tR", "<cmd>Telescope registers<cr>", { desc = "Registers" })
map({ "i", "n", "v", "s" }, "<leader>tk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map({ "i", "n", "v", "s" }, "<leader>tC", "<cmd>Telescope commands<cr>", { desc = "Commands" })

-- File Operations
map({ "i", "n", "v", "s" }, "<leader>Gn", "<cmd>lua require('genghis').createNewFile()<cr>", { desc = "New File" })
map({ "i", "n", "v", "s" }, "<leader>Gr", "<cmd>lua require('genghis').renameFile()<cr>", { desc = "Rename File" })
map({ "i", "n", "v", "s" }, "<leader>Gp", "<cmd>lua require('genghis').copyFilepath()<cr>", { desc = "Copy File Path" })
map({ "i", "n", "v", "s" }, "<leader>GN", "<cmd>lua require('genghis').copyFilename()<cr>", { desc = "Copy File Name" })
map({ "i", "n", "v", "s" }, "<leader>Gx", "<cmd>lua require('genghis').chmodx()<cr>", { desc = "chmod x" })
map(
  { "i", "n", "v", "s" },
  "<leader>Gm",
  "<cmd>lua require('genghis').moveAndRenameFile()<cr>",
  { desc = "Move and Rename" }
)
map(
  { "i", "n", "v", "s" },
  "<leader>Gd",
  "<cmd>lua require('genghis').duplicateFile()<cr>",
  { desc = "Duplicate File" }
)
map(
  { "i", "n", "v", "s" },
  "<leader>Gs",
  "<cmd>lua require('genghis').moveSelectionToNewFile()<cr>",
  { desc = "Move Selection to New File" }
)
map({ "i", "n", "v", "s" }, "<leader>GX", "<cmd>lua require('genghis').trashFile()<cr>", { desc = "Delete File" })

-- Maximizer (F3  already mapped by plugin)
map({ "n" }, "<C-w>m", "<cmd>MaximizerToggle!<cr>", { desc = "Maximize" })

-- emacs-style motion & editing in insert mode
map({ "i" }, [[<C-a>]], [[<Home>]]) -- "Goto beginning of line")
map({ "i" }, [[<C-e>]], [[<End>]]) -- "Goto end of line")
map({ "i" }, [[<C-b>]], [[<Left>]]) --Goto char backward"
map({ "i" }, [[<C-f>]], [[<Right>]]) -- "Goto char forward")
map({ "i" }, [[<M-b>]], [[<S-Left>]]) -- "Goto word backward")
map({ "i" }, [[<M-f>]], [[<S-Right>]]) -- "Goto word forward")
map({ "i" }, [[<C-d>]], [[<Delete>]]) -- "Kill char forward")
map({ "i" }, [[<M-d>]], [[<C-o>de]]) -- "Kill word forward")
map({ "i" }, [[<M-Backspace>]], [[<C-o>dB]]) -- "Kill word backward")
map({ "i" }, [[<C-k>]], [[<C-o>D]]) -- "Kill to end of line")

-- emacs-style motion & editing in command mode
map({ "c" }, [[<C-a>]], [[<Home>]]) -- Goto beginning of line
map({ "c" }, [[<C-b>]], [[<Left>]]) -- Goto char backward
map({ "c" }, [[<C-d>]], [[<Delete>]]) -- Kill char forward
map({ "c" }, [[<C-f>]], [[<Right>]]) -- Goto char forward
map({ "c" }, [[<C-g>]], [[<C-c>]]) -- Cancel
map({ "c" }, [[<C-k>]], [[<C-\>e(" ".getcmdline())[:getcmdpos()-1][1:]<Cr>]]) -- Kill to end of line
map({ "c" }, [[<M-f>]], [[<C-\>euser#fn#cmdlineMoveWord( 1, 0)<Cr>]]) -- Goto word forward
map({ "c" }, [[<M-b>]], [[<C-\>euser#fn#cmdlineMoveWord(-1, 0)<Cr>]]) -- Goto word backward
map({ "c" }, [[<M-d>]], [[<C-\>euser#fn#cmdlineMoveWord( 1, 1)<Cr>]]) -- Kill word forward
map({ "c" }, [[<M-Backspace>]], [[<C-\>euser#fn#cmdlineMoveWord(-1, 1)<Cr>]]) -- Kill word backward

-- Visual Split Plugin
map({ "v", "n", "x" }, "<C-w>gr", [[<cmd>'<,'>VSResize<cr>]], { remap = true })
map({ "v", "n", "x" }, "<C-w>gss", [[<cmd>'<,'>VSSplit<cr>]], { remap = true })
map({ "v", "n", "x" }, "<C-w>gsa", [[<cmd>'<,'>VSSplitAbove<cr>]], { remap = true })
map({ "v", "n", "x" }, "<C-w>gsb", [[<cmd>'<,'>VSSplitBelow<cr>]], { remap = true })

-- Trying to get sane copy/paste over
map({ "x", "v" }, "p", '"_dP')

-- Window Picker

local picker = require("window-picker")
vim.keymap.set("n", ",w", function()
  local picked_window_id = picker.pick_window({
    include_current_win = true,
  }) or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, { desc = "Pick a window" })

-- Swap two windows using the awesome window picker
-- FIX: This function is not working
vim.keymap.set("n", ",e", function()
  local other_window = picker.pick_window({
    include_current_win = false,
  })
  local target_buffer = vim.fn.winbufnr(other_window)
  vim.api.nvim_win_set_buf(other_window, 0)
  vim.api.nvim_win_set_buf(0, target_buffer)
end, { desc = "Swap windows" })
