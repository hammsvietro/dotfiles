let mapleader = "\<Space>"

call plug#begin('~/.vim/plugged')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'sindrets/diffview.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'alvan/vim-closetag'
  Plug 'morhetz/gruvbox'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'jiangmiao/auto-pairs'
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'mattn/emmet-vim'
  Plug 'neovimhaskell/haskell-vim'
  Plug 'tpope/vim-surround'
  Plug 'TimUntersberger/neogit'
  Plug 'dart-lang/dart-vim-plugin'
  Plug 'thosakwe/vim-flutter'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
  Plug 'tpope/vim-commentary'
  Plug 'elixir-editors/vim-elixir'
  Plug 'jvirtanen/vim-hcl'
  Plug 'rebelot/kanagawa.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
call plug#end()

lua require('treesitter_setup')
lua require('bufferline_setup')
lua require('colorizer_setup')
lua require('nvim_tree_setup')
lua require('neogit_setup')
lua require('lualine_setup')

