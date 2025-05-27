# proot.nvim

Lightweight project navigator with telescope

![圖片](https://github.com/user-attachments/assets/b2661a98-4455-4350-a2c2-1a105e853a75)

## Features

* Autodetect by using lsp and files to save project root dir
* Use telescope to search and change root dir

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
    lsp = nil, -- ignore lsp clients by name e.g. { "pyright", "tsserver" }
  },
  events = {
    -- called when you change the directory
    entered = function(path)
    end
  },
}
```

## Usage

Open proot picker by calling `:Proot`  
In proot picker you can use `d` to delete project dir

## Tips

I like to close all buffers and restart lsp after I switch repo

```lua
events = {
  entered = function (path)
    vim.fn.chdir(path)
    vim.cmd("bufdo bd")
    vim.cmd("LspRestart")
  end
}
```

## Similar Plugin

[ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim) - The superior project management solution for neovim.
