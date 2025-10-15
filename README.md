# proot.nvim

Lightweight project navigator with picker

![圖片](https://github.com/user-attachments/assets/b2661a98-4455-4350-a2c2-1a105e853a75)

## Features

* Autodetect by using lsp and files to save project root dir
* Allow freely renaming projects for easier management

## Installation

With lazy.nvim
```lua
{
  "zongben/proot.nvim",
  opts = {}
}
```

### Telescope Extension

For users with Telescope installed

```lua
require("telescope").load_extension("proot")
```

### Snacks Sources

For users with Snacks installed, proot automatically registers its sources.

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
    entered = function(name, path)
    end
  },
}
```

## Usage

### Telescope Extension

Open picker by calling `require("telescope").extensions.proot.open_picker()`

### Snacks Sources

Open picker by calling `:Proot`

### Picker

In proot picker you can use `d` to delete project dir and use `r` to rename project name virtually

## Tips

I like to close all buffers and restart LSP servers after I switched repositories

```lua
events = {
  entered = function ()
    vim.cmd("bufdo bd")

    for _, client in pairs(vim.lsp.get_clients()) do
      vim.lsp.stop_client(client)
    end
  end
}
```

## Similar Plugin

[ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim) - The superior project management solution for neovim.
