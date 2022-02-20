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
vim.o.cursorline = false            -- hl current line
vim.o.backup = false
vim.o.fileencoding = "utf-8"
vim.o.showmode = false
vim.o.undofile = true
vim.o.sidescrolloff = 8
vim.o.updatetime = 1000             -- CursorHold time less long (also swapfile but this is unused)

local current_dir = require("user.utils").split(vim.fn.getcwd(), "/")
local current_repo = current_dir[#current_dir]
local noabexpand_dirs = {
  "c_fib",
  "odintomqtt",
}

for _, dir in ipairs(noabexpand_dirs) do
  if(dir == current_repo) then
    vim.o.expandtab = false
  end
end

local tab8_dirs = {
  "c_fib",
  "odintomqtt",
}

for _, dir in ipairs(tab8_dirs) do
  if(dir == current_repo) then
    vim.o.shiftwidth = 8
    vim.o.tabstop = 8
    vim.o.softtabstop = 8
  end
end

local tab2_dirs = {
  "nvim",
}

for _, dir in ipairs(tab2_dirs) do
  if(dir == current_repo) then
    vim.o.shiftwidth = 2
    vim.o.tabstop = 2
    vim.o.softtabstop = 2
  end
end

