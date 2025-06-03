local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local theme = require("telescope.themes")
local detector = require("proot.detector")

local picker
local _events

local M = {}

local make_displayer = function(entry)
  return entry_display.create({
    separator = " ",
    items = {
      { width = 20 },
      { remaining = true },
    },
  })({ entry.name, { entry.value, "Comment" } })
end

local entry_maker = function(entry)
  local name = vim.fn.fnamemodify(entry, ":t")
  return {
    name = name,
    value = entry,
    display = make_displayer,
    ordinal = 1,
  }
end

local new_picker = function()
  local projects = detector.get_projects()
  picker = pickers.new(theme.get_dropdown(), {
    prompt_title = "Proot",
    finder = finders.new_table({
      results = projects,
      entry_maker = entry_maker,
    }),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.fn.chdir(selection.value)
        if _events.entered then
          _events.entered(selection.value)
        end
        detector.move_project_to_top(selection.value)
      end)
      map("n", "d", M.delete_project)
      return true
    end,
  })
  picker:find()
end

local refresh_picker = function()
  picker:refresh(finders.new_table({
    results = detector.get_projects(),
    entry_maker = entry_maker,
  }))
end

M.init = function(events)
  _events = events
end

M.delete_project = function()
  local projects = detector.get_projects()
  local path = action_state.get_selected_entry().value
  for i, project in ipairs(projects) do
    if project == path then
      table.remove(projects, i)
      detector.set_projects(projects)
      refresh_picker()
      return
    end
  end
end

M.open_proot_picker = function()
  new_picker()
end

return M
