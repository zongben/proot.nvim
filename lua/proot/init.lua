local config = require("proot.config")
local detector = require("proot.detector")
local cmd = require("proot.cmd")

local M = {}

M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", config.defaults, opts or {})

  detector.init(M.options.files)
  cmd.init()
end

return M
