let mapleader = "\<Space>"
set termguicolors

call plug#begin('~/.vim/plugged')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'kyazdani42/nvim-web-devicons' " for file icons
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'alvan/vim-closetag'
  Plug 'rktjmp/lush.nvim'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'jiangmiao/auto-pairs'
  Plug 'akinsho/bufferline.nvim'
  Plug 'famiu/feline.nvim', {'commit': '4ef5e1516395eea731275e0f58b6bfba5c6ac9c1'}
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'mattn/emmet-vim'
call plug#end()

lua require('feline_setup')
lua require('treesitter_setup')
lua require('bufferline_setup')
lua require('colorizer_setup')
lua require('nvim_tree_setup')

