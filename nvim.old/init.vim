let mapleader = "\<Space>"
call plug#begin('~/.vim/plugged')

  " optional deps
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-tree/nvim-web-devicons'

  " buffer bar
  Plug 'romgrk/barbar.nvim'

  " git
  Plug 'sindrets/diffview.nvim'
  Plug 'TimUntersberger/neogit'
  Plug 'f-person/git-blame.nvim'
  " status bar
  Plug 'nvim-lualine/lualine.nvim'

  " file tree
  Plug 'kyazdani42/nvim-tree.lua'

  " autocomplete/syntax highlight/editor
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-context'
  Plug 'm4xshen/autoclose.nvim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'folke/todo-comments.nvim'

  " fuzzy finder
  Plug 'nvim-telescope/telescope.nvim'

  " language specific
  Plug 'dart-lang/dart-vim-plugin'
  Plug 'elixir-editors/vim-elixir'
  Plug 'mhinz/vim-mix-format'
  Plug 'jvirtanen/vim-hcl'
  Plug 'alvan/vim-closetag'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'neovimhaskell/haskell-vim'
  Plug 'thosakwe/vim-flutter'


  " colorscheme
  Plug 'dasupradyumna/midnight.nvim'
call plug#end()

lua require('treesitter_setup')
lua require('colorizer_setup')
lua require('nvim_tree_setup')
lua require('neogit_setup')
lua require('lualine_setup')
lua require('autoclose_setup')
lua require('todo_comments_setup')
lua require('devicons_setup')
lua require('telescope_setup')
