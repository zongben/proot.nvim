# proot.nvim

Lightweight project navigator with Telescope

![圖片](https://github.com/user-attachments/assets/d21f7614-a361-4496-8033-83b8bf058c7e)

## Features

* Autodetect and save project root dir
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
  config = function()
    require("proot").setup()
  end,
}
```

## Configuration

The default configuration is as follows
```lua
{
  files = { ".git" }
}
```

## Usage

Open proot picker by calling `:Proot`  
In proot picker you can use `d` to delete project dir

## Similar Plugin

[ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim) - The superior project management solution for neovim. 
