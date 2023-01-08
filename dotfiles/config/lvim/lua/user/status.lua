local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.style = "lvim"

-- lvim.builtin.lualine.on_config_done = function()
--   lvim.builtin.lualine.sections.lualine_a[1][1] = "mode"
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

  lvim.builtin.lualine.sections.lualine_c ={
    "%F",
    components.diff,
    components.python_env,
  }

end
