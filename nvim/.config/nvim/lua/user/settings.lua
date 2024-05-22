-- Line numbers
vim.opt.number = true 
vim.opt.relativenumber = true

vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true -- Wrap lines

vim.opt.cursorline = true -- Enables cursor line

-- Ignorecase when searching only lower letter
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true -- Split to the right on vertical
vim.opt.splitbelow = true -- Split below when horizontal

vim.opt.swapfile = false -- Don't use swap files (I use auto-save.nvim instead)
vim.opt.formatoptions:append('cro') -- continue comments when going down a line, hit C-u to remove the added comment prefix

-- always copy to global clipboard
vim.api.nvim_set_option("clipboard", "unnamedplus")
