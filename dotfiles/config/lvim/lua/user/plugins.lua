-- Lunarvim has core plugins already installed:
-- https://www.lunarvim.org/docs/plugins/core-plugins-list
-- Extra plugins added:
lvim.plugins = {

  -- Inlay Hints for LSP and Rust
  "lvimuser/lsp-inlayhints.nvim", -- needed because rust-tools inlay is broken
  "simrat39/rust-tools.nvim",

  -- Multicursor (ctrl up/down, ctrl-N)
  -- Ctrl Mouse Click
  -- \\ = leader
  -- \\\ = add cursor at position
  -- \\-A = Select all cwords in the file and create a cursor for it
  -- \\-/ = regex search adding cursor for matches
  -- \\-\ = cursor at position
  -- C-N + S-S" (add surround)
  -- C-Up-Down + \\-< + (char)  = align
  -- C-Up-Down + \\-0n (\\-N or \\-n) = Append numbers starting on 0
  -- select `sep`(:) - C-N - (multi cursor on all) -
  --                  \\-a (align)
  --                  \\-d (duplicate)
  --                  \\-C (case conversion)
  -- C-Down - f: (find `:`) - \\a (align)
  -- \\-` = tools menu
  -- C-N - mii - c (select, match inner function, change)
  "mg979/vim-visual-multi",

  -- Indentation text object (vai, vii, vaI, viI)
  "michaeljsmith/vim-indent-object",

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
  -- ,e - exchange window position
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

  -- Complete function signature as we type (handle by lsp)
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },

  -- Github Copilot and autocomplete
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

  -- Remembers where you cursor was when you closed the file
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
    -- alternative: run =  function() vim.fn["mkdp#util#install"](),
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

  -- media_files extension doesn't work well
  -- "nvim-telescope/telescope-media-files.nvim",

  --Show status of LSP
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },

  -- Runs HTTP requests
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
  -- {
  --   "folke/drop.nvim",
  --   event = "VimEnter",
  --   config = function()
  --     require("drop").setup({
  --       theme = "leaves",
  --       filetypes = {},
  --     })
  --   end,
  -- },

  -- Annoying notification popups
  -- {
  --   "rcarriga/nvim-notify",
  --   config = function()
  --     require("notify").setup()
  --   end
  -- },

  -- Quick moves inside document
  -- S or s__ or f F t T
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup({ teasing = false })
    end,
  },

  -- Better input popups and UI
  "stevearc/dressing.nvim",

  -- Persist sessions
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

  -- Literate programming
  {
    "metakirby5/codi.vim",
    cmd = "Codi",
  },

  -- Python debugging
  "mfussenegger/nvim-dap-python",

  -- Maximizer (it can be done with C-w | and C-w _ and Ctrl w =)
  -- Other option is opening in a new tab with C-w T
  -- Another useful tip is :tabedit % (to maximize) :tabclose (to get back)
  -- but this plugin remembers the size of multiple windows
  -- <C-w>m or F3
  "szw/vim-maximizer",

  -- Select a range and split it with <C-w>gr/gss/gsa/gsb
  { 'wellle/visual-split.vim', cmd = { 'VSResize', 'VSSplit', 'VSSplitAbove', 'VSSplitBelow' } },

  -- Splitjoin gS, gJ
  "AndrewRadev/splitjoin.vim",

  -- Remove trailing lines and spaces
  { 'echasnovski/mini.trailspace', branch = 'stable' },

  -- Creates dirs when `:w path`
  'jghauser/mkdir.nvim',

  -- :Cheatsheet for vim commands
  {
    'sudormrfbin/cheatsheet.nvim',
    config = function()
      require('cheatsheet').setup()
    end,
    requires = {
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    }
  },

  -- <leader>i inverts text under cursor
  -- true, on, up, !=, left, yes
  -- 5 > 4  5 >= 6, 6 <= 6,
  -- let x = Some
  {
    'nguyenvukhang/nvim-toggler',
    config = function()
      require('nvim-toggler').setup({
        inverses = {
          ["vim"] = "emacs",
          ["<"] = ">",
          [">="] = "<=",
          ["True"] = "False",
          ["Up"] = "Down",
          ["Left"] = "Right",
          ["Some"] = "None",
        }
      })
    end,
  },

  -- File operations like `<l>gd` (duplicate file)
  {
    "chrisgrieser/nvim-genghis",
    requires = {
      "stevearc/dressing.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-omni",
    },
  },

  -- Automations
  {
    'arjunmahishi/flow.nvim',
    config = function()
      require('flow').setup({
        output = {
          buffer = true,
          split_cmd = '20split',
        },
        filetype_cmd_map = {
          hurl = "echo %s | hurl | jq",
          -- hurl = "hurl <<-EOF\n%s\nEOF | jq",
        }
      })
      require('flow.vars').add_vars({
        name = "Bruno",
        var_with_func = function()
          return "test"
        end,
      })
    end,
  },

  -- Adds a border to windows
  {
    "nvim-zh/colorful-winsep.nvim",
    config = function()
      require('colorful-winsep').setup({
        symbols = { "─", "│", "┌", "┐", "└", "┘" },
      })
    end,
  },
}
