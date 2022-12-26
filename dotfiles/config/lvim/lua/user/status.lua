lvim.builtin.lualine.style = "lvim"
-- lvim.builtin.lualine.on_config_done = function()
--   lvim.builtin.lualine.sections.lualine_a[1][1] = "mode"
-- end

-- local function show_macro_recording()
--     local recording_register = vim.fn.reg_recording()
--     if recording_register == "" then
--         return ""
--     else
--         return "Recording @" .. recording_register
--     end
-- end

lvim.builtin.lualine.on_config_done = function()
  lvim.builtin.lualine.sections.lualine_a[1].padding = 1
  lvim.builtin.lualine.sections.lualine_a[1][1] = function()
    local mode = require("lualine.utils.mode").get_mode()
    local map = {
      ["NORMAL"] = "N" .. lvim.icons.ui.Target,
      ["INSERT"] = "I" .. lvim.icons.ui.Pencil,
      ["REPLACE"] = "R",
      ["V-REPLACE"] = "VR",
      ["VISUAL"] = "V",
      ["V-LINE"] = "L",
      ["V-BLOCK"] = "B",
      ["SELECT"] = "S",
      ["S-LINE"] = "SL",
      ["COMMAND"] = ":",
      ["EX"] = "EX",
      ["MORE"] = lvim.icons.ui.Ellipsis,
      ["CONFIRM"] = lvim.icons.diagnostics.BoldQuestion,
      ["O-PENDING"] = "OP",
      ["SHELL"] = "ﲵ",
      ["TERMINAL"] = "",
    }
    return map[mode]
  end

  lvim.builtin.lualine.sections.lualine_c[3] = {
      require("noice").api.status.mode.get,
      cond = require("noice").api.status.mode.has,
      color = { fg = "#ff9e64" },
  }
  -- lvim.builtin.lualine.sections.lualine_c[4] = {
  --     require("noice").api.status.message.get_hl,
  --     cond = require("noice").api.status.message.has,
  --     color = { fg = "#ff9e64" },
  -- }

    -- {
    --   require("noice").api.status.message.get_hl,
    --   cond = require("noice").api.status.message.has,
    -- },
    -- {
    --   require("noice").api.status.command.get,
    --   cond = require("noice").api.status.command.has,
    --   color = { fg = "#ff9e64" },
    -- },
    -- {
    --   require("noice").api.status.mode.get,
    --   cond = require("noice").api.status.mode.has,
    --   color = { fg = "#ff9e64" },
    -- },
    -- {
    --   require("noice").api.status.search.get,
    --   cond = require("noice").api.status.search.has,
    --   color = { fg = "#ff9e64" },
    -- },
end
