return {

  -- Automations
  {
    "arjunmahishi/flow.nvim",
    config = function()
      require("flow").setup({
        output = {
          buffer = true,
          split_cmd = "20split",
        },
        filetype_cmd_map = {
          hurl = "echo %s | hurl | jq",
          -- hurl = "hurl <<-EOF\n%s\nEOF | jq",
        },
      })
      require("flow.vars").add_vars({
        name = "Bruno",
        var_with_func = function()
          return "test"
        end,
      })
    end,
  },
}
