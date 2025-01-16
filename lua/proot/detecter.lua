local saver = require("proot.saver")
local scandir = require("plenary.scandir")

local _files = {}
local _projects = {}

local find_file = function(path, files)
  for _, file in ipairs(files) do
    if path:find(file) then
      return true
    end
  end
  return false
end

local save = function ()
  saver.save(_projects)
end

local add_project = function (path)
  path = path:gsub("\\", "/")
  if vim.tbl_contains(_projects, path) then
    return
  end

  table.insert(_projects, path)
  save()
end

local M = {}

M.init = function(files)
  local projects = saver.load()
  if projects then
    _projects = projects
  end
  _files = files
  M.file_detect()
  M.lsp_detect()
end

M.getProjects = function()
  return _projects
end

M.setProjects = function(projects)
  _projects = projects
  save()
end

M.file_detect = function()
  local current_dir = vim.fn.getcwd()
  local paths = scandir.scan_dir(current_dir, {
    hidden = true,
    respect_gitignore = false,
    add_dirs = true,
    depth = 1,
  })

  for _, path in ipairs(paths) do
    if find_file(path, _files) then
      add_project(current_dir)
      return
    end
  end
end

M.lsp_detect = function()
  vim.api.nvim_create_autocmd({ "LspAttach" }, {
    pattern = "*",
    callback = function(handler)
      local bufnr = handler.buf
      local clients = vim.lsp.get_clients({
        bufnr = bufnr,
      })

      for _, client in ipairs(clients) do
        local root_dir = client.root_dir
        if root_dir then
          add_project(root_dir)
        end
      end
    end,
  })
end

return M
