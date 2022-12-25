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
  -- { "zbirenbaum/copilot.lua",
  --   event = { "VimEnter" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup {
  --         plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
  --       }
  --     end, 100)
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua" },
  --   config = function()
  --     require("copilot_cmp").setup {
  --       formatters = {
  --         insert_text = require("copilot_cmp.format").remove_existing,
  --       },
  --     }
  --   end,
  -- },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    requires = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
      end, 100)
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
  {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },
      })
    end
  },
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
      require('modes').setup({
        colors = {
          copy = "#f5c359",
          delete = "#c75c6a",
          insert = "#78ccc5",
          visual = "#9745be",
        },
        -- Set opacity for cursorline and number background
        line_opacity = 0.15,

        -- Enable cursor highlights
        set_cursor = true,

        -- Enable cursorline initially, and disable cursorline for inactive windows
        -- or ignored filetypes
        set_cursorline = true,

        -- Enable line number highlights to match cursorline
        set_number = true,

        -- Disable modes highlights in specified filetypes
        -- Please PR commonly ignored filetypes
        ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
      })
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
  -- Cycle buffer c-h and c-l
  "ghillb/cybu.nvim",
  -- Prevents closing window layouts
  "moll/vim-bbye",
  -- Show indent guides even on blank lines
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require('indent_blankline').setup {
        char = '┊',
        show_trailing_blankline_indent = false,
      }
    end,
  },
  -- media_files extension doesn't work well
  -- "nvim-telescope/telescope-media-files.nvim",
  --Show status of LSP
  -- {
  --   "j-hui/fidget.nvim",
  --   config = function()
  --     require("fidget").setup()
  --   end,
  -- },
  {
    "rest-nvim/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = true,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = true,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = true,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to nil if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end
          },
        },
        -- Jump to request line on run
        jump_to_request = true,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })
    end
  },
  -- Surrounds
  --    Old text                    Command         New text
  --------------------------------------------------------------------------------
  -- surr*ound_words             ysiw)           (surround_words)
  -- *make strings               ys$"            "make strings"
  -- [delete ar*ound me!]        ds]             delete around me!
  -- remove <b>HTML t*ags</b>    dst             remove HTML tags
  -- 'change quot*es'            cs'"            "change quotes"
  -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
  -- delete(functi*on calls)     dsf             function calls
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end
  },
  -- UI improvements (mostly useless but cool)
  {
    "folke/drop.nvim",
    event = "VimEnter",
    config = function()
      require("drop").setup({
        theme = "snow"
      })
    end,
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup()
    end
  },
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end,
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  -- Change colortheme depending on filetype
  {
    "folke/styler.nvim",
    config = function()
      require("styler").setup({
        themes = {
          markdown = { colorscheme = "catppuccin-frappe" },
          -- help = { colorscheme = "catppuccin-mocha", background = "dark" },
        },
      })
    end,
  },
  -- Better inputs and UI
  "stevearc/dressing.nvim",
  -- PErsist sessions
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    config = function()
      require("persistence").setup()
    end,
  },
  -- Texto objects allows wuick moves like `cif` change inner function
  "nvim-treesitter/nvim-treesitter-textobjects",

}
