vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.swapfile = false
vim.o.scrolloff = 20
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = false
vim.o.wrapscan = false
vim.o.backup = false
vim.o.fileencoding = "utf-8"
vim.o.showmode = false
vim.o.undofile = true
vim.o.sidescrolloff = 8
vim.o.updatetime = 1000
vim.o.cursorline = true
vim.o.laststatus = 3
vim.o.mouse = ""
vim.o.wrap = false
vim.o.completeopt = "menuone,noselect,fuzzy,popup,preinsert"
vim.o.pumheight = 20
vim.opt.shortmess:append("c")
vim.opt.shortmess:append("C")
vim.o.clipboard = "unnamedplus"
vim.g.health = { style = "float" }
-- don't fold
vim.o.foldlevel = 1000
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"

vim.api.nvim_create_user_command("DotNetBuildDiag", require("user.utils").dotnet_build_diag, {})

vim.api.nvim_set_hl(0, "ExtraWhitespace", { fg = "darkgreen", bg = "darkgreen" })
vim.fn.matchadd("ExtraWhitespace", "\\s\\+\\%#\\@<!$")
