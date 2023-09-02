return {
  -- :MarkdownPreview live on the browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    -- alternative: run =  function() vim.fn--------[[ [--[[ [ [[ [[ ["mkdp#util#install"] ]] ]] ] ]]] ]](),
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
