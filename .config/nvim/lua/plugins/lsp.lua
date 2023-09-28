return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.black,
        nls.builtins.formatting.prettierd,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.mix,
        nls.builtins.formatting.rustfmt,
        nls.builtins.formatting.elm_format,
      })
    end,
    dependencies = {
      "mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(
          opts.ensure_installed,
          { "black", "black", "prettierd", "shfmt", "stylua", "ormolu", "elixir-ls", "typescript-language-server" }
        )
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    opts = {
      servers = {
        elmls = {},
        elixirls = {
          cmd = { "elixir-ls" },
          settings = {
            elixirLS = {
              dialyzerEnabled = false,
            },
          },
        },
        clangd = {},
        pyright = {
          settings = {
            filetypes = { "python" },
            python = {
              exclude = { "venv" },
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        tsserver = {},
        hls = {
          settings = {
            haskell = {
              cabalFormattingProvider = "cabalfmt",
              formattingProvider = "ormolu",
            },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },
}
