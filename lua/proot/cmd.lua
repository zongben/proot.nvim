local tele = require("proot.tele")

local M = {}

local open_proot_picker = function()
  vim.api.nvim_create_user_command("Proot", tele.open_proot_picker, {
    nargs = 0,
    complete = nil,
  })
end

M.init = function()
  open_proot_picker()
end

return M
