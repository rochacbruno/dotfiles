-- Additional Plugins
lvim.plugins = {
  -- Inlay Hints for LSP and Rust
  "lvimuser/lsp-inlayhints.nvim",
  "simrat39/rust-tools.nvim",
  -- Multicursor (ctrl up/down, ctrl-N)
  "mg979/vim-visual-multi",
  -- highlight TODO:comments
  "folke/todo-comments.nvim",
  -- highlight colors like  #ffcc00
  "NvChad/nvim-colorizer.lua",
  -- Group all the problems in a quick fix list (leader-zz)
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  -- :ZenMode for writing
  "folke/zen-mode.nvim",
  -- Internal scrollbar
  "petertriho/nvim-scrollbar",
  -- Search and Replace across all files
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup({
        live_update = true,
        is_insert_mode = true,
      })
    end,
  },
  -- ,w - shows window picker when working with splits
  {
    "s1n7ax/nvim-window-picker",
    tag = "1.*",
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal" },
          },
        },
        fg_color = "#11111b",
        current_win_hl_color = "#f5e0dc",
        other_win_hl_color = "#f38ba8",
      })
    end,
  },
  -- :DiffViewOpen/Close - For git diffs
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  -- IDK if this next one is needed
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require "lsp_signature".on_attach() end,
  -- },
  { "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
          plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
        }
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup {
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing,
        },
      }
    end,
  },
  -- Markdown viewer embedded
  {
    "npxbr/glow.nvim",
    ft = { "markdown" }
    -- run = "yay -S glow"
  },
  -- Remenbers where you cursor was when you closed the file
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  -- highlight the occurences of the word behind the cursor
  {
    "itchyny/vim-cursorword",
    event = { "BufEnter", "BufNewFile" },
    config = function()
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },
  -- Theme 
  { "catppuccin/nvim", as = "catppuccin" },
  -- :MarkdownPreview live on the browser
  { "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  -- Highlights the current mode changing line color
  {
    'mvllow/modes.nvim',
    tag = 'v0.2.0',
    config = function()
      require('modes').setup()
    end
  },
  -- Rust crates helper 
  {
    "saecki/crates.nvim",
    tag = "v0.3.0",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      }
    end,
  },
}
