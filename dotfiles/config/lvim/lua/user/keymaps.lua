vim.leader = "space"
-- Map Ctrl + s on normal and insert mode
lvim.keys.normal_mode["<C-s>"] = ":update<cr>"
lvim.keys.insert_mode["<C-s>"] = "<Esc>:update<CR>a"
lvim.keys.visual_mode["<C-s>"] = "<Esc>:update<CR>v"
lvim.keys.normal_mode["<C-z>"] = ":undo<cr>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Toggle lsp-lines
lvim.builtin.which_key.mappings["l"]["t"] = {"<cmd>lua require'lsp_lines'.toggle()<CR>", "Toggle Diagnostic Lines"}


-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
  t = {"<cmd>ToggleTermToggleAll<cr>", "Term Toggle"}
}

lvim.builtin.which_key.mappings["x"] = {
  name = "Rest",
  r = { "<cmd>lua require'rest-nvim'.run(false)<cr>", "Run" },
  p = { "<cmd>lua require'rest-nvim'.run(true)<cr>", "Preview" },
  a = { "<cmd>lua require'rest-nvim'.last()<cr>", "Last Request" },
  o = { "<cmd>lua require('user.functions').open_rest_nvim_file()<cr>", "Open rest file" }
}

lvim.builtin.which_key.mappings["b"]["t"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Text in Buffer" }
lvim.builtin.which_key.mappings["b"]["p"] = { "<cmd>BufferLinePick<cr>", "Pick a Buffer" }

lvim.builtin.which_key.mappings["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" }

lvim.builtin.which_key.mappings["o"] = { "<cmd>NvimTreeFocus<CR>", "Focus Explorer" }
-- lvim.builtin.which_key.mappings["v"] = { "<cmd>vsplit<cr>", "vsplit" }

lvim.builtin.which_key.mappings["r"] = {
  name = "Replace",
  r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
  w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
  f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
  s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace Cursor Word" },
}

lvim.builtin.which_key.mappings["d"] = {
  name = "Debug",
  b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
  c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
  o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
  O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
  r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
  l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
  u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
  x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
}

lvim.builtin.which_key.mappings["q"] = {
  q = { "<cmd>lua require('lvim.utils.functions').smart_quit()<CR>", "Quit" },
  s = { [[<cmd>lua require("persistence").load()<cr>]], "Restore pwd session" },
  l = { [[<cmd>lua require("persistence").load({ last = true })<cr>]], "Last Session" },
  d = { [[<cmd>lua require("persistence").stop()<cr>]], "Dont save current session" }
}

lvim.builtin.which_key.mappings["f"] = {
  name = "Find",
  b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
  c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
  f = { "<cmd>Telescope find_files<cr>", "Find files" },
  d = { "<cmd>Telescope fd<cr>", "Find files with Preview" },
  t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
  s = { "<cmd>Telescope grep_string<cr>", "Find String" },
  h = { "<cmd>Telescope help_tags<cr>", "Help" },
  H = { "<cmd>Telescope highlights<cr>", "Highlights" },
  i = { "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", "Media" },
  l = { "<cmd>Telescope resume<cr>", "Last Search" },
  M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
  r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
  R = { "<cmd>Telescope registers<cr>", "Registers" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
  C = { "<cmd>Telescope commands<cr>", "Commands" },
}

lvim.builtin.which_key.mappings["g"] = {
  name = "Genghis File Operations",
  n = { "<cmd>lua require('genghis').createNewFile()<cr>", "New File" },
  r = { "<cmd>lua require('genghis').renameFile()<cr>", "Rename File" },
  p = { "<cmd>lua require('genghis').copyFilepath()<cr>", "Copy File Path" },
  N = { "<cmd>lua require('genghis').copyFilename()<cr>", "Copy File Name" },
  x = { "<cmd>lua require('genghis').chmodx()<cr>", "chmod x" },
  m = { "<cmd>lua require('genghis').moveAndRenameFile()<cr>", "Move and Rename" },
  d = { "<cmd>lua require('genghis').duplicateFile()<cr>", "Duplicate File" },
  s = { "<cmd>lua require('genghis').moveSelectionToNewFile()<cr>", "Move Selection to New File" },
  X = { "<cmd>lua require('genghis').trashFile()<cr>", "Delete File" },
}

vim.keymap.set("x", "<ScrollWheelLeft>", "5z<Left>")
vim.keymap.set("x", "<ScrollWheelRight>", "5z<Right>")

-- Remove the Ctrl-\ for terminal
lvim.builtin.terminal.open_mapping = "<c-t>"
-- Enable the use of C-l to clean the terminal
lvim.keys.term_mode = { ["<C-l>"] = false }


-- Dont message help for which_key
lvim.builtin.which_key.setup["show_help"] = false
lvim.builtin.which_key.setup["show_keys"] = false

-- Replace fFtT with Hop
-- place this in one of your configuration file(s)
pcall(function()
  local hop = require('hop')
  local directions = require('hop.hint').HintDirection
  vim.keymap.set('', 'f', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
  end, { remap = true })
  vim.keymap.set('', 'F', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
  end, { remap = true })
  vim.keymap.set('', 't', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
  end, { remap = true })
  vim.keymap.set('', 'T', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
  end, { remap = true })
  vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
  vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
end
)

-- Maximize window
-- F3 is already mapped by plugin
vim.keymap.set('n', '<C-w>m', "<Cmd>MaximizerToggle!<CR>")
vim.keymap.set('n', '<C-w>z', "<cmd>ZenMode<cr>")

-- emacs-style motion & editing in insert mode
vim.keymap.set("i", [[<C-a>]], [[<Home>]]) -- "Goto beginning of line")
vim.keymap.set("i", [[<C-e>]], [[<End>]]) -- "Goto end of line")
vim.keymap.set("i", [[<C-b>]], [[<Left>]]) --Goto char backward"
vim.keymap.set("i", [[<C-f>]], [[<Right>]]) -- "Goto char forward")
vim.keymap.set("i", [[<M-b>]], [[<S-Left>]]) -- "Goto word backward")
vim.keymap.set("i", [[<M-f>]], [[<S-Right>]]) -- "Goto word forward")
vim.keymap.set("i", [[<C-d>]], [[<Delete>]]) -- "Kill char forward")
vim.keymap.set("i", [[<M-d>]], [[<C-o>de]]) -- "Kill word forward")
vim.keymap.set("i", [[<M-Backspace>]], [[<C-o>dB]]) -- "Kill word backward")
vim.keymap.set("i", [[<C-k>]], [[<C-o>D]]) -- "Kill to end of line")

-- emacs-style motion & editing in command mode
vim.keymap.set("c", [[<C-a>]], [[<Home>]]) -- Goto beginning of line
vim.keymap.set("c", [[<C-b>]], [[<Left>]]) -- Goto char backward
vim.keymap.set("c", [[<C-d>]], [[<Delete>]]) -- Kill char forward
vim.keymap.set("c", [[<C-f>]], [[<Right>]]) -- Goto char forward
vim.keymap.set("c", [[<C-g>]], [[<C-c>]]) -- Cancel
vim.keymap.set("c", [[<C-k>]], [[<C-\>e(" ".getcmdline())[:getcmdpos()-1][1:]<Cr>]]) -- Kill to end of line
vim.keymap.set("c", [[<M-f>]], [[<C-\>euser#fn#cmdlineMoveWord( 1, 0)<Cr>]]) -- Goto word forward
vim.keymap.set("c", [[<M-b>]], [[<C-\>euser#fn#cmdlineMoveWord(-1, 0)<Cr>]]) -- Goto word backward
vim.keymap.set("c", [[<M-d>]], [[<C-\>euser#fn#cmdlineMoveWord( 1, 1)<Cr>]]) -- Kill word forward
vim.keymap.set("c", [[<M-Backspace>]], [[<C-\>euser#fn#cmdlineMoveWord(-1, 1)<Cr>]]) -- Kill word backward

-- Visual Split Plugin
vim.keymap.set({ "v", "n", "x" }, "<C-w>gr", [[<cmd>'<,'>VSResize<cr>]], { remap = true })
vim.keymap.set({ "v", "n", "x" }, "<C-w>gss", [[<cmd>'<,'>VSSplit<cr>]], { remap = true })
vim.keymap.set({ "v", "n", "x" }, "<C-w>gsa", [[<cmd>'<,'>VSSplitAbove<cr>]], { remap = true })
vim.keymap.set({ "v", "n", "x" }, "<C-w>gsb", [[<cmd>'<,'>VSSplitBelow<cr>]], { remap = true })

-- Trying to get sane copy/paste over
vim.keymap.set({ "x", "v" }, "p", '"_dP')
