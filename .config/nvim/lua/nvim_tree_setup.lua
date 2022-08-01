require'nvim-tree'.setup({
  filters = {
    dotfiles = false,
  },
  filesystem_watchers = {
    enable = true,
  },
  view = {
    adaptive_size = true,
    side = "left",
    width = 25,
  },
  renderer = {
    indent_markers = {
      enable = true,
      inline_arrows = true,
      root_folder_modifier = ":~",
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        none = " ",
      },
    },
  },    
})

vim.cmd([[

let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \ }
]])
