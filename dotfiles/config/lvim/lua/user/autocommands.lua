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

-- TRIM whitespace on specified patterns when saving.
autocmd({ "BufWritePre" }, {
  pattern = {
    "*.py",
    "*.rs",
    "*.toml",
    "*.yaml",
    "*.txt",
    "*.in",
    "*.lua",
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
            timeout = 40,
        })
    end,
})

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
