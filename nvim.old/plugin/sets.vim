set tabstop=2
set shiftwidth=0
set encoding=utf-8
set expandtab
set smartindent
set guicursor=
set relativenumber
set nu
set smartcase
set nohlsearch
set hidden
set noerrorbells
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set colorcolumn=90
set signcolumn=yes
set mouse=a
set autoread


set cmdheight=2

set updatetime=50

set shortmess+=c

let g:neovide_transparency=1
set guifont=FiraCode\ Nerd\ Font:h12


let g:mix_format_on_save = 1
let g:mix_format_silent_errors = 1


" trigger `autoread` when files changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" notification after file change
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None