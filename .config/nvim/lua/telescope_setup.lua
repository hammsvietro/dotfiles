require('telescope').setup{ 
  defaults = { 
    file_ignore_patterns = { 
      "node_modules/",
      "deps/",
      "_build/",
      ".elixir_ls/",
    },

    mappings = {
      n = {
    	  ['<c-d>'] = require('telescope.actions').delete_buffer
      },
      i = {
    	  ['<c-d>'] = require('telescope.actions').delete_buffer
      }
    }
  }
}
