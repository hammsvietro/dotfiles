vim.opt.guicursor = "a:block"
vim.opt.swapfile = false
vim.o.autoread = true
vim.opt.clipboard = ""
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
