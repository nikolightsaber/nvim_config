local opts = { noremap = true }
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<Enter>", "o<Esc>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)

keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

keymap("n", "<C-PageUp>", ":bp<CR>", opts)
keymap("n", "<C-PageDown>", ":bn<CR>", opts)

keymap("n", "<F5>", ":setlocal spell! spelllang=en_us<CR>", opts)
keymap("n", "<F6>", ":setlocal spell! spelllang=nl<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

keymap("v", "//", "y/\\V<C-R>=escape(@\",\'/\\\')<CR><CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- stop scrolling
keymap("n", "<Up>", "", opts)
keymap("n", "<Down>", "", opts)

function _G.ReplaceWithRegister(type)
  if(type == nil) then
    vim.o.operatorfunc = "v:lua.ReplaceWithRegister"
    return "g@"
  end

  local start = vim.api.nvim_buf_get_mark(0, "[")[2]
  local stop = vim.api.nvim_buf_get_mark(0, "]")[2]
  local line = vim.api.nvim_get_current_line()
  local new = vim.fn.getreg("+")
  line = line:sub(1, start) .. new .. line:sub(stop + 2, -1)
  vim.api.nvim_set_current_line(line)
end

keymap("n", "gr", "v:lua.ReplaceWithRegister()", { noremap = true, expr = true })
keymap("n", "grr", "v:lua.ReplaceWithRegister()", { noremap = true, expr = true })

keymap("n", "<F7>", '', { noremap = true, callback = require("user.utils").highlight_log })
