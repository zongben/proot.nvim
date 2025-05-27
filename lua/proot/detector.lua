local saver = require("proot.saver")
local scandir = require("plenary.scandir")

local _files = {}
local _ignore = {}
local _projects = {}

local find_file = function(path, files)
  for _, file in ipairs(files) do
    if vim.fn.fnamemodify(path, ":t") == file then
      return true
    end
  end
  return false
end

local save = function()
  saver.save(_projects)
end

local add_project = function(path)
  path = path:gsub("\\", "/")
  for _, project in ipairs(_projects) do
    if string.lower(project) == string.lower(path) then
      return
    end
  end

  table.insert(_projects, path)
  save()
end

local M = {}

M.init = function(files, ignore, detector)
  local projects = saver.load()
  if projects then
    _projects = projects
  end
  _files = files
  _ignore = ignore
  if detector.enable_file_detect then
    vim.notify("PRoot: File detection enabled")
    M.file_detect()
  end
  if detector.enable_lsp_detect then
    vim.notify("PRoot: LSP detection enabled")
    M.lsp_detect()
  end
end

M.move_project_to_top = function(path)
  for i, project in ipairs(_projects) do
    if string.lower(project) == string.lower(path) then
      table.remove(_projects, i)
      table.insert(_projects, 1, path)
      save()
      return
    end
  end
end

M.get_projects = function()
  return _projects
end

M.set_projects = function(projects)
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
        if vim.tbl_contains(_ignore.lsp or {}, client.name) then
          return
        end

        local root_dir = client.root_dir
        if root_dir then
          add_project(root_dir)
        end
      end
    end,
  })
end

return M
