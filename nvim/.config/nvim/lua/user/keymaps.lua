-- set the leader key to <Space>
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- remap escape
vim.keymap.set('i', 'jj', '<ESC>', {})

-- shortcuts for telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})

-- disable arrow keys in every mode
vim.keymap.set('n', '<Up>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('n', '<Down>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('n', '<Left>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('n', '<Right>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('i', '<Up>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('i', '<Down>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('i', '<Left>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('i', '<Right>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('v', '<Up>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('v', '<Down>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('v', '<Left>', ":echoe 'Stop using arrow keys!'<CR>")
vim.keymap.set('v', '<Right>', ":echoe 'Stop using arrow keys!'<CR>")
