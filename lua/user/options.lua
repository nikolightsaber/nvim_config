M = {}
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.number = true
vim.o.relativenumber = false
vim.o.swapfile = false
vim.o.scrolloff = 8
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.backup = false
vim.o.fileencoding = "utf-8"
vim.o.showmode = false
vim.o.undofile = true
vim.o.sidescrolloff = 8
vim.o.updatetime = 1000             -- CursorHold time less long (also swapfile but this is unused)
vim.o.cursorline = true
vim.o.laststatus = 3

return M
