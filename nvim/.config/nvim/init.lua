-- lazy nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require('lazy').setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "lambdalisue/suda.vim" },
  { "echasnovski/mini.starter", version = "*" },
  { 
    "nvim-telescope/telescope.nvim", tag = "0.1.5", 
    dependencies = { 'nvim-lua/plenary.nvim' } 
  },
})

-- source user settings
require('user.settings')
require('user.keymaps')
require('user.commands')

-- source plugin configs
require('plugins/mini-starter')
require('plugins/catppuccin')

