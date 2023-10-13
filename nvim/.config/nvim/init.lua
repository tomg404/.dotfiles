vim.opt.number = true -- Enables line numbers
vim.opt.relativenumber = true -- Enables relative line numbers

vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.cursorline = true -- Enables cursor line
vim.opt.ignorecase = true -- Ignore case when searching

vim.opt.splitright = true -- Split to the right on vertical
vim.opt.splitbelow = true -- Split below when horizontal

vim.opt.swapfile = false -- Don't use swap files (I use auto-save.nvim instead)
vim.opt.wrap = true -- Wrap lines
vim.opt.updatetime = 100 -- mainly for trld.nvim which utilize CursorHold autocmd
vim.opt.formatoptions:append('cro') -- continue comments when going down a line, hit C-u to remove the added comment prefix
vim.opt.sessionoptions:remove('options') -- don't save keymaps and local options
vim.opt.foldlevelstart = 99 -- no auto folding