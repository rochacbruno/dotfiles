lvim.leader = "space"
-- Map Ctrl + s on normal and insert mode
lvim.keys.normal_mode["<C-s>"] = ":update<cr>"
lvim.keys.insert_mode["<C-s>"] = "<Esc>:update<CR>a"
lvim.keys.visual_mode["<C-s>"] = "<Esc>:update<CR>v"

-- vim.keymap.set("i", "<c-s>", "<Esc>:w<CR>a", { silent = true, noremap = true })

-- Map Ctrl + z to `undo`
lvim.keys.normal_mode["<C-z>"] = ":undo<cr>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

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
}

lvim.builtin.which_key.mappings["x"] = {
  name = "Rest",
  r = { "<cmd>lua require'rest-nvim'.run()<cr>", "Run" },
  p = { "<cmd>lua require'rest-nvim'.run(true)<cr>", "Preview" },
  a = { "<cmd>lua require'rest-nvim'.last()<cr>", "Last Request" },
  o = { "<cmd>lua require('user.functions').open_rest_nvim_file()<cr>", "Open rest file" }
}

lvim.builtin.which_key.mappings["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" }
-- lvim.builtin.which_key.mappings["v"] = { "<cmd>vsplit<cr>", "vsplit" }

lvim.builtin.which_key.mappings["r"] = {
  name = "Replace",
  r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
  w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
  f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
  s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace Cursor Word" },
}

-- Replace all similar words
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


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

-- Paste over selection
vim.keymap.set("x", "<leader>p", "\"_dP")
lvim.builtin.which_key.mappings["p"] = { "\"_dP", "Paste Over" }



vim.keymap.set("x", "<ScrollWheelLeft>", "5z<Left>")
vim.keymap.set("x", "<ScrollWheelRight>", "5z<Right>")


-- Remove the Ctrl-\ for terminal
lvim.builtin.terminal.open_mapping = "<c-t>"
-- Enable the use of C-l to clean the terminal
lvim.keys.term_mode = { ["<C-l>"] = false }

-- Dont message help for which_key
lvim.builtin.which_key.setup["show_help"] = false
lvim.builtin.which_key.setup["show_keys"] = false

