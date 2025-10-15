local telescope = require("telescope")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local theme = require("telescope.themes")
local detector = require("proot.detector")
local conf = require("telescope.config").values
local proot = require("proot")

local M = {}

local function create_finder()
  local displayer = entry_display.create({
    separator = " ",
    items = {
      {
        width = 20,
      },
      {
        remaining = true,
      },
    },
  })

  local function make_display(entry)
    return displayer({ entry.name, { entry.value, "Comment" } })
  end

  return finders.new_table({
    results = detector.get_projects(),
    entry_maker = function(entry)
      return {
        display = make_display,
        name = entry.name,
        value = entry.path,
        ordinal = entry.name,
      }
    end,
  })
end

local new_picker = function()
  pickers
    .new(theme.get_dropdown(), {
      prompt_title = "Proot",
      finder = create_finder(),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(_, map)
        actions.select_default:replace(function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.fn.chdir(selection.value)
          if proot.options.events.entered then
            proot.options.events.entered(selection.name, selection.value)
          end
          detector.move_project_to_top(selection.value)
        end)
        map("n", "d", M.delete_project)
        map("n", "r", M.rename_project)
        return true
      end,
    })
    :find()
end

local refresh_picker = function(prompt_bufnr)
  local finder = create_finder()
  action_state.get_current_picker(prompt_bufnr):refresh(finder, {
    reset_prompt = true,
  })
end

M.delete_project = function(prompt_bufnr)
  local projects = detector.get_projects()
  local path = action_state.get_selected_entry().value
  for i, project in ipairs(projects) do
    if project.path == path then
      table.remove(projects, i)
      detector.set_projects(projects)
      refresh_picker(prompt_bufnr)
      return
    end
  end
end

M.rename_project = function(prompt_bufnr)
  local selected_entry = action_state.get_selected_entry()
  local input = vim.fn.input("Rename project: ", selected_entry.name)

  if input == "" then
    return
  end

  local projects = detector.get_projects()
  for _, project in ipairs(projects) do
    if project.path == selected_entry.value then
      project.name = input
      detector.set_projects(projects)
      refresh_picker(prompt_bufnr)
      return
    end
  end
end

M.open_proot_picker = function()
  new_picker()
end

return telescope.register_extension({
  exports = {
    open_picker = M.open_proot_picker,
  },
})
