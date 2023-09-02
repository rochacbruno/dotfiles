return {
  -- ,w - shows window picker when working with splits
  -- ,e - exchange window position
  -- {
  --   "s1n7ax/nvim-window-picker",
  --   version = "1.*",
  --   config = function()
  --     require("window-picker").setup({
  --       autoselect_one = true,
  --       include_current = false,
  --       filter_rules = {
  --         -- filter using buffer options
  --         bo = {
  --           -- if the file type is one of following, the window will be ignored
  --           filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },
  --
  --           -- if the buffer type is one of following, the window will be ignored
  --           buftype = { "terminal" },
  --         },
  --       },
  --       fg_color = "#11111b",
  --       current_win_hl_color = "#f5e0dc",
  --       other_win_hl_color = "#f38ba8",
  --     })
  --   end,
  -- },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        -- hint = "floating-big-letter",
        show_prompt = false,
        filter_rules = {
          autoselect_one = true,
          include_current_win = false,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix", "NvimTree" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal" },
          },
        },
      })
    end,
    -- config = function()
    --   require("window-picker").setup()
    -- end,
  },
}
