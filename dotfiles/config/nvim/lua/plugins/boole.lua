return {

  -- Same as toggler but uses C-a, C-x
  {
    url = "https://github.com/nat-418/boole.nvim",
    config = function()
      require("boole").setup({
        mappings = {
          increment = "<C-a>",
          decrement = "<C-x>",
        },
        -- User defined loops
        additions = {
          { "Foo", "Bar" },
          { "tic", "tac", "toe" },
        },
        allow_caps_additions = {
          { "enable", "disable" },
          -- enable → disable
          -- Enable → Disable
          -- ENABLE → DISABLE
        },
      })
    end,
  },
}
