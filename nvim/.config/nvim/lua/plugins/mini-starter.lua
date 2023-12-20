-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-starter.md

local starter = require('mini.starter')
starter.setup({
  items = {
    starter.sections.recent_files(10, true),
    starter.sections.builtin_actions(),
  },
})

