return {

  -- Adds a border to windows
  {
    "nvim-zh/colorful-winsep.nvim",
    config = function()
      require("colorful-winsep").setup({
        symbols = { "─", "│", "┌", "┐", "└", "┘" },
      })
    end,
  },
}
