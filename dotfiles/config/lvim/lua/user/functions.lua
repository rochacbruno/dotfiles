M = {}

-- To bind this function to a key:
-- "<cmd>lua require('user.functions').open_rest_nvim_file()<cr>"

M.open_rest_nvim_file = function()
  -- Opens the pwd/rest_nvim/test.http file if exists
  -- Otherwise it creates the file and then opens it

  local pwd = vim.fn.getcwd() -- vim.fn.expand("%:p:h")

  local rest_nvim_file = pwd .. "/rest_nvim/test.http"
  if vim.fn.filereadable(rest_nvim_file) == 1 then
    vim.cmd("vsplit " .. rest_nvim_file)
  else
    vim.cmd("!mkdir -p rest_nvim")
    vim.fn.writefile({}, rest_nvim_file)
    vim.cmd("vsplit " .. rest_nvim_file)
  end
end


vim.api.nvim_create_user_command("RestNvimFile", M.open_rest_nvim_file, {})


M.save_as_sudo = function()
  vim.cmd("w !sudo -S tee %")
end

vim.api.nvim_create_user_command("SaveAsSudo", M.save_as_sudo, {})

return M
