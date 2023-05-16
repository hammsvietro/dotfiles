require('lualine').setup {
  options = {
    -- ... your lualine config
    theme = 'onenord'
    -- ... your lualine config
  }
}
require('onenord').setup({
  theme = nil, -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
  borders = true, -- Split window borders
  fade_nc = false, -- Fade non-current windows, making them more distinguishable
  -- Style that is applied to various groups: see `highlight-args` for options
  styles = {
    comments = "NONE",
    strings = "NONE",
    keywords = "NONE",
    functions = "NONE",
    variables = "NONE",
    diagnostics = "underline",
  },
  disable = {
    background = false, -- Disable setting the background color
    cursorline = false, -- Disable the cursorline
    eob_lines = true, -- Hide the end-of-buffer lines
  },
  -- Inverse highlight for different groups
  inverse = {
    match_paren = false,
  },
  custom_highlights = {}, -- Overwrite default highlight groups
  custom_colors = {}, -- Overwrite default colors
})





-- require("catppuccin").setup {
-- 	flavour = "mocha", -- latte, frappe, macchiato, mocha
-- 	term_colors = true,
-- 	transparent_background = false,
-- 	no_italic = false,
-- 	no_bold = false,
-- 	styles = {
-- 		comments = {},
-- 		conditionals = {},
-- 		loops = {},
-- 		functions = {},
-- 		keywords = {},
-- 		strings = {},
-- 		variables = {},
-- 		numbers = {},
-- 		booleans = {},
-- 		properties = {},
-- 		types = {},
-- 	},
-- 	color_overrides = {
-- 		mocha = {
-- 			base = "#000000",
-- 			mantle = "#000000",
-- 			crust = "#000000",
-- 		},
-- 	},
-- 	highlight_overrides = {
-- 		mocha = function(C)
-- 			return {
-- 				TabLineSel = { bg = C.pink },
-- 				CmpBorder = { fg = C.surface2 },
-- 				Pmenu = { bg = C.none },
-- 				TelescopeBorder = { link = "FloatBorder" },
-- 			}
-- 		end,
-- 	},
-- }
