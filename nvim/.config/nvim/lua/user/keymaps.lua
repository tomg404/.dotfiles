local opts = { noremap = true, silent = true }

-- set the leader key to <Space>
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- remap escape
vim.keymap.set('i', 'jj', '<ESC>', {})

-- shortcuts for telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, opts)
vim.keymap.set('n', '<leader>fg', telescope.live_grep, opts)

-- disable arrow keys in every mode
vim.keymap.set({'n', 'v'}, '<Up>',    ":echoe 'Stop using arrow keys!'<CR>", opts)
vim.keymap.set({'n', 'v'}, '<Down>',  ":echoe 'Stop using arrow keys!'<CR>", opts)
vim.keymap.set({'n', 'v'}, '<Left>',  ":echoe 'Stop using arrow keys!'<CR>", opts)
vim.keymap.set({'n', 'v'}, '<Right>', ":echoe 'Stop using arrow keys!'<CR>", opts)
vim.keymap.set('i', '<Up>',    "<ESC> :echoe 'Stop using arrow keys!<CR>", opts)
vim.keymap.set('i', '<Down>',  "<ESC> :echoe 'Stop using arrow keys!<CR>", opts)
vim.keymap.set('i', '<Left>',  "<ESC> :echoe 'Stop using arrow keys!<CR>", opts)
vim.keymap.set('i', '<Right>', "<ESC> :echoe 'Stop using arrow keys!<CR>", opts)

