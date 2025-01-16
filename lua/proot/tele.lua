local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local theme = require("telescope.themes")
local detecter = require("proot.detecter")

local picker

local M = {}

local new_picker = function()
  local projects = detecter.getProjects()
  picker = pickers.new(theme.get_dropdown(), {
    prompt_title = "Proot",
    finder = finders.new_table({
      results = projects,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = 1,
        }
      end,
    }),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("bufdo bd")
        vim.fn.chdir(selection.value)
        vim.api.nvim_set_current_dir(selection.value)
      end)
      map("n", "d", M.delete_project)
      return true
    end,
  })
  picker:find()
end

local refresh_picker = function()
  picker:refresh(finders.new_table({
    results = detecter.getProjects(),
    entry_maker = function(entry)
      return {
        value = entry,
        display = entry,
        ordinal = 1,
      }
    end,
  }))
end

M.delete_project = function()
  local projects = detecter.getProjects()
  local path = action_state.get_selected_entry().value
  for i, project in ipairs(projects) do
    if project == path then
      table.remove(projects, i)
      detecter.setProjects(projects)
      refresh_picker()
      return
    end
  end
end

M.open_project_picker = function()
  new_picker()
end

M.init = function()
  vim.api.nvim_create_user_command("Proot", "lua require('proot.tele').open_project_picker()", {
    nargs = 0,
    complete = nil,
  })
end

return M
