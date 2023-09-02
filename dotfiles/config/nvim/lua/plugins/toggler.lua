return {

  -- <leader>i inverts text under cursor
  -- true, on, up, !=, left, yes
  -- 5 > 4  5 >= 6, 6 <= 6,
  -- let x = Some
  {
    "nguyenvukhang/nvim-toggler",
    config = function()
      require("nvim-toggler").setup({
        inverses = {
          ["vim"] = "emacs",
          ["<"] = ">",
          [">="] = "<=",
          ["True"] = "False",
          ["Up"] = "Down",
          ["Left"] = "Right",
          ["Some"] = "None",
        },
      })
    end,
  },
}
