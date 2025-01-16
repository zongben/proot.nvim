# proot.nvim

Lightweight project navigator with telescope

![圖片](https://github.com/user-attachments/assets/b2661a98-4455-4350-a2c2-1a105e853a75)

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
  opts = {}
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
