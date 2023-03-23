call plug#begin()
	Plug 'preservim/nerdtree'
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
call plug#end()

" Editor theme
let g:tokyonight_style = "storm"
"let g:tokyonight_style = "night"
"let g:tokyonight_style = "day"
let g:tokyonight_transparent = "true"
colorscheme tokyonight

" Spaces & Tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line

" Line Numbers
set number

" Line wrapping
set nowrap

"
Plug 'glepnir/dashboard-nvim'
Plug 'liuchengxu/vim-clap'

let g:mapleader="\<Space>"
nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nmap <Leader>cn :<C-u>DashboardNewFile<CR>
nnoremap <silent> <Leader>fh :<C-u>Clap history<CR>
nnoremap <silent> <Leader>ff :<C-u>Clap files ++finder=rg --ignore --hidden --files<cr>
nnoremap <silent> <Leader>tc :<C-u>Clap colors<CR>
nnoremap <silent> <Leader>fa :<C-u>Clap grep2<CR>
nnoremap <silent> <Leader>fb :<C-u>Clap marks<CR>
nnoremap <silent> <Leader>cn :<C-u>DashboardNewFile<CR>

let g:dashboard_custom_shortcut={
  \ 'last_session'       : 'SPC s l',
  \ 'find_history'       : 'SPC f h',
  \ 'find_file'          : 'SPC f f',
  \ 'new_file'           : 'SPC c n',
  \ 'change_colorscheme' : 'SPC t c',
  \ 'find_word'          : 'SPC f a',
  \ 'book_marks'         : 'SPC f b',
  \ }
