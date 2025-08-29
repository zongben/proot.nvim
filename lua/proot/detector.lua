local saver = require("proot.saver")
local scandir = require("plenary.scandir")

local _files = {}
local _ignore = {}
local _projects = {}
local _ignored_path = {}
local _detected_event = nil

local insert_project = function(name, path, index)
  if not index then
    index = #_projects + 1
  end

  table.insert(_projects, index, {
    name = name,
    path = path,
  })
end

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

local start_with = function(str, prefix)
  return string.sub(str, 1, #prefix) == prefix
end

local add_project = function(path)
  path = path:gsub("\\", "/")
  if vim.tbl_contains(_ignored_path, path) then
    return
  end

  for _, project in ipairs(_projects) do
    if string.lower(project.path) == string.lower(path) then
      return
    end

    if _ignore.subpath and start_with(path, project.path) then
      table.insert(_ignored_path, path)
      return
    end
  end

  local name = vim.fn.fnamemodify(path, ":t")
  insert_project(name, path, 1)

  if _detected_event then
    _detected_event(name, path)
  end

  save()
end

local M = {}

M.init = function(files, ignore, detector, detected_event)
  _detected_event = detected_event
  local projects = saver.load()
  if projects then
    _projects = projects
  end
  _files = files
  _ignore = ignore
  if detector.enable_file_detect then
    M.file_detect()
  end
  if detector.enable_lsp_detect then
    M.lsp_detect()
  end
end

M.move_project_to_top = function(path)
  for i, project in ipairs(_projects) do
    if string.lower(project.path) == string.lower(path) then
      local name = project.name
      table.remove(_projects, i)
      insert_project(name, path, 1)
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
