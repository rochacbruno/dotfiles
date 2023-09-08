-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.cursorcolumn = true
opt.relativenumber = true
opt.showcmd = true
opt.virtualedit = "onemore"

vim.g["mkdp_theme"] = "light"
vim.g["VM_mouse_mappings"] = 1
vim.lsp.set_log_level("debug")
