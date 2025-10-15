local detector = require("proot.detector")
local proot = require("proot")

local function truncate(text, width)
  if #text > width then
    return text:sub(1, width - 1) .. "…"
  end
  return text
end

local M = {}

M.open_picker = function()
  ---@class snacks.picker.Config
  local config = {
    source = "proot",
    title = "Proot",
    preview = "none",
    layout = {
      preset = "select",
    },
    finder = function()
      local items = {}
      for index, value in ipairs(detector.get_projects()) do
        table.insert(items, {
          idx = index,
          name = value.name,
          text = value.name,
          path = value.path,
        })
      end
      return items
    end,
    format = function(item)
      return {
        { string.format("%-20s", truncate(item.name, 20)) },
        { item.path, "SnacksPickerComment" },
      }
    end,
    win = {
      input = {
        keys = {
          ["d"] = { "delete_project", mode = { "n" } },
          ["r"] = { "rename_project", mode = { "n" } },
        },
      },
    },
    actions = {
      confirm = function(_, item)
        vim.fn.chdir(item.path)
        if proot.options.events.entered then
          proot.options.events.entered(item.name, item.path)
        end
        detector.move_project_to_top(item.path)
      end,
      delete_project = function(picker, item)
        local projects = detector.get_projects()
        for i, project in ipairs(projects) do
          if project.path == item.path then
            table.remove(projects, i)
            detector.set_projects(projects)
            picker:find()
            return
          end
        end
      end,
      rename_project = function(picker, item)
        local input = vim.fn.input("Rename project: ", item.name)

        if input == "" then
          return
        end

        local projects = detector.get_projects()
        for _, project in ipairs(projects) do
          if project.path == item.path then
            project.name = input
            detector.set_projects(projects)
            picker:find()
            return
          end
        end
      end,
    },
  }

  Snacks.picker.pick(config)
end

return M
