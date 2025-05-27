local config = require("proot.config")
local detector = require("proot.detector")
local cmd = require("proot.cmd")
local tele = require("proot.tele")

local M = {}

M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", config.defaults, opts or {})

  tele.init(M.options.events)
  detector.init(M.options.files, M.options.ignore, M.options.detector)
  cmd.init()
end

return M
