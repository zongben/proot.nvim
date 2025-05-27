local M = {}

M.defaults = {
  detector = {
    enable_file_detect = true,
    enable_lsp_detect = true,
  },
  files = { ".git" },
  ignore = {
    lsp = nil,
  },
  events = {
    entered = nil,
  },
}

return M
