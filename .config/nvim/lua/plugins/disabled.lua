return {
  { "echasnovski/mini.indentscope", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "echasnovski/mini.surround", enabled = false },
  {
    "hrsh7th/nvim-cmp",
    enalbed = false,
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
    end,
  },
  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
      },
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "folke/flash.nvim",
    enabled = false,
  },
  { "saadparwaiz1/cmp_luasnip", enabled = false },
  { "hrsh7th/cmp-path", enabled = false },
  { "hrsh7th/cmp-emoji", enabled = false },
  { "hrsh7th/cmp-buffer", enabled = false },
  { "RRethy/vim-illuminate", enabled = false },
}
