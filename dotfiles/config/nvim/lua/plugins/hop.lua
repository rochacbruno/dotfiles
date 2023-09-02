return {
  -- Quick moves inside document
  -- S or s__ or f F t T
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup({ teasing = false })
    end,
  },
}
