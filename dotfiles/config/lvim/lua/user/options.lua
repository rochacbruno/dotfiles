vim.opt.cursorcolumn = true
vim.opt.cmdheight = 0
vim.opt.relativenumber = true
-- vim.opt.spell = false  -- this doesnt work, so done in aucommand
vim.g["mkdp_theme"] = "light"
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "catppuccin-mocha"

lvim.builtin.alpha.dashboard.section.header.val = {
  [[                                ]],
  [[  ____                          ]],
  [[ | __ ) _ __ _   _ _ __   ___   ]],
  [[ |  _ \| '__| | | | '_ \ / _ \  ]],
  [[ | |_) | |  | |_| | | | | (_) | ]],
  [[ |____/|_|   \__,_|_| |_|\___/  ]],
  [[                                ]],
  [[          __       __           ]],
  [[         / <`     '> \          ]],
  [[        (  / @   @ \  )         ]],
  [[         \(_ _\_/_ _)/          ]],
  [[       (\ `-/     \-' /)        ]],
  [[        "===\     /==="         ]],
  [[         .==')___(`==.          ]],
  [[        ' .='     `=.           ]],
}

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.filters.custom = {
  "*.egg-info",
  ".venv",
  ".git",
  "__pycache__",
  "**/__pycache__",
}

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
  "markdown",
  "http",
  "vim",
  "regex",
  "markdown_inline",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- Text Objects
--
lvim.builtin.treesitter.textobjects = {
  select = {
    enable = true,
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    keymaps = {
      -- You can use the capture groups defined in textobjects.scm
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["at"] = "@class.outer",
      ["it"] = "@class.inner",
      ["ac"] = "@call.outer",
      ["ic"] = "@call.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
      ["ai"] = "@conditional.outer",
      ["ii"] = "@conditional.inner",
      ["a/"] = "@comment.outer",
      ["i/"] = "@comment.inner",
      ["ab"] = "@block.outer",
      ["ib"] = "@block.inner",
      ["as"] = "@statement.outer",
      ["is"] = "@scopename.inner",
      ["aA"] = "@attribute.outer",
      ["iA"] = "@attribute.inner",
      ["aF"] = "@frame.outer",
      ["iF"] = "@frame.inner",
    },
  },
}
