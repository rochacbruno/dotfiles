local executors = require "rust-tools.executors"
require("rust-tools").setup {
  tools = {
    executor = executors.toggleterm,
    runnables = {
      use_telescope = true,
    },
    autoSetHints = true,
    inlay_hints = { show_parameter_hints = true },
    hover_actions = { auto_focus = true }
  },
  server = {
    cmd = { "~/bin/rust-analyzer" },
    on_attach = function(client, bufnr)
      require("lvim.lsp").common_on_attach(client, bufnr)
      local rt = require "rust-tools"
      vim.keymap.set("n", "<leader>lA", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
    on_init = require("lvim.lsp").common_on_init,
    settings = {
      ["rust-analyzer"] = {
        rustfmt = {
          extraArgs = { "+nightly", },
        },
        -- diagnostics = {
        --     disabled = { "unresolved-proc-macro" },
        lens = {
          enable = true,
        },
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
}
