return {
  { "echasnovski/mini.indentscope", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "echasnovski/mini.surround", enabled = false },
  { "nvim-treesitter-textobjects", enabled = false },
  { "folke/persistence.nvim", enabled = false },
  { "folke/neodev.nvim", enabled = false },
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
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
      },
      lsp_doc_border = false,
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "folke/flash.nvim",
    enabled = false,
  },
  { "saadparwaiz1/cmp_luasnip", enabled = false },
  { "stevearc/dressing.nvim", enabled = false },
  { "hrsh7th/cmp-path", enabled = false },
  { "hrsh7th/cmp-emoji", enabled = false },
  { "hrsh7th/cmp-buffer", enabled = false },
  { "RRethy/vim-illuminate", enabled = false },
  { "nvim-treesitter/nvim-treesitter-context", enabled = false },
}
