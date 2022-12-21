-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }


-- local function filter(arr, func)
--   -- Filter in place
--   -- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
--   local new_index = 1
--   local size_orig = #arr
--   for old_index, v in ipairs(arr) do
--     if func(v, old_index) then
--       arr[new_index] = v
--       new_index = new_index + 1
--     end
--   end
--   for i = new_index, size_orig do arr[i] = nil end
-- end

-- local function filter_diagnostics(diagnostic)
--   -- Only filter out Pyright stuff for now
--   if diagnostic.source ~= "Pyright" then
--     return true
--   end

--   -- Allow kwargs to be unused, sometimes you want many functions to take the
--   -- same arguments but you don't use all the arguments in all the functions,
--   -- so kwargs is used to suck up all the extras
--   if diagnostic.message == '"kwargs" is not accessed' then
--     return false
--   end

--   -- Allow variables starting with an underscore
--   if string.match(diagnostic.message, '"_.+" is not accessed') then
--     return false
--   end

--   if string.match(diagnostic.message, 'Cannot access member') then
--     return false
--   end

--   return true
-- end

-- local function custom_on_publish_diagnostics(a, params, client_id, c, config)
--   filter(params.diagnostics, filter_diagnostics)
--   lvim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
-- end

-- lvim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   custom_on_publish_diagnostics, {})
