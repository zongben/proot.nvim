# proot.nvim

Lightweight project navigator with telescope

![圖片](https://github.com/user-attachments/assets/b2661a98-4455-4350-a2c2-1a105e853a75)

## Features

* Autodetect by using lsp and files to save project root dir
* Use telescope to search and change root dir
* Allow freely renaming projects for easier management

## Installation

With lazy.nvim
```lua
{
  "zongben/proot.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  opts = {}
}
```

## Configuration

The default configuration is as follows
```lua
{
  detector = {
    enable_file_detect = true,
    enable_lsp_detect = true,
  },
  files = { ".git" },
  ignore = {
    subpath = true, --If you are using monorepo, set to true to ignore subrepos
    lsp = nil, -- ignore lsp clients by name e.g. { "pyright", "tsserver" }
  },
  events = {
    -- called when new project is found
    detected = function(name, path)
    end
    -- called when you change the directory
    entered = function(path)
    end
  },
}
```

## Usage

Open proot picker by calling `:Proot`  
In proot picker you can use `d` to delete project dir and use `r` to rename project name virtually

## Tips

I like to close all buffers and restart LSP servers after I switched repositories

```lua
events = {
  entered = function (path)
    vim.cmd("bufdo bd")

    for _, client in pairs(vim.lsp.get_clients()) do
      vim.lsp.stop_client(client)
    end
  end
}
```

For users who use toggleterm and lazygit, you can set the directory of lazygit each time you launch it.  
This way, each time proot switches to a new directory, lazygit can also switch to the new path accordingly.

```lua
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "curved",
  },
})
function Lazygit_toggle()
  lazygit.dir = vim.fn.getcwd()
  lazygit:toggle()
end
```

## Similar Plugin

[ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim) - The superior project management solution for neovim.
