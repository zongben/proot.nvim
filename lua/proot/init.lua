local config = require("proot.config")
local detector = require("proot.detector")

local M = {}

M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", config.defaults, opts or {})
  detector.init(M.options)

  if Snacks then
    vim.api.nvim_create_user_command("Proot", function()
      require("proot.snacks").open_picker()
    end, {
      nargs = 0,
      complete = nil,
    })
  end
end

return M
