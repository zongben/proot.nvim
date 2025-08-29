local M = {}

M.defaults = {
  detector = {
    enable_file_detect = true,
    enable_lsp_detect = true,
  },
  files = { ".git" },
  ignore = {
    subpath = true,
    lsp = nil,
  },
  events = {
    detected = nil,
    entered = nil,
  },
}

return M
