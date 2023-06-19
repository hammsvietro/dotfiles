require('telescope').setup{ 
  defaults = { 
    file_ignore_patterns = { 
      "node_modules/",
      "deps/",
      "_build/",
      ".elixir_ls/",
    }
  }
}
