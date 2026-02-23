local util = require("lspconfig.util")
return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.black,
        nls.builtins.formatting.prettierd,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.mix,
        nls.builtins.formatting.rust_analyzer,
        nls.builtins.formatting.elm_format,
      })
    end,
    dependencies = {
      "mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {
          "pyright",
          "black",
          "prettierd",
          "shfmt",
          "stylua",
          "ormolu",
          "elixir-ls",
          "clangd",
          "typescript-language-server",
          "gopls",
        })
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
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
        gopls = {},
        clangd = {},
        pyright = {
            root_dir = util.root_pattern("pyproject.toml", "setup.py", "requirements.txt", ".git"),
            before_init = function(_, config)
                local root = config.root_dir
                local candidates = {
                root .. "/.venv/bin/python",
                root .. "/venv/bin/python",
                }
                for _, p in ipairs(candidates) do
                if vim.loop.fs_stat(p) then
                    config.settings = config.settings or {}
                    config.settings.python = config.settings.python or {}
                    config.settings.python.pythonPath = p
                    return
                end
                end
            end,
            settings = {
                python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "openFilesOnly",
                    useLibraryCodeForTypes = true,
                    exclude = { "**/venv/**", "**/__pycache__/**", "**/.venv/**" },
                },
                },
            },
        },
        tsserver = {},
        rust_analyzer = {},
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
