local opts = { noremap = true }
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<Enter>", "o<Esc>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
-- Don't go to next one yet
keymap("n", "*", "*Nzz", opts)

keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

keymap("n", "<C-PageUp>", ":bp<CR>", opts)
keymap("n", "<C-PageDown>", ":bn<CR>", opts)

keymap("n", "<F6>", ":setlocal spell! spelllang=en_us<CR>", opts)
--keymap("n", "<F6>", ":setlocal spell! spelllang=nl<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

keymap("v", "//", "y/\\V<C-R>=escape(@\",\'/\\\')<CR><CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("v", "p", '"_dP', opts)

-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv=gv", opts)
keymap("x", "K", ":move '<-2<CR>gv=gv", opts)

-- stop scrolling
keymap("n", "<Up>", "", opts)
keymap("n", "<Down>", "", opts)

keymap("n", "<leader>y", "\"+y", opts)
keymap("n", "<leader>Y", "\"+y$", opts)
keymap("n", "<leader>p", "\"+p", opts)
keymap("n", "<leader>P", "\"+P", opts)

keymap("v", "<leader>y", "\"+y", opts)
keymap("v", "<leader>p", "\"+p", opts)
keymap("v", "<leader>P", "\"+P", opts)

keymap("x", "<leader>y", "\"+y", opts)
keymap("x", "<leader>p", "\"+p", opts)
keymap("x", "<leader>P", "\"+P", opts)

local _reg = ""
function _G.ReplaceWithRegister(type, reg)
  if (type == "") then
    _reg = reg;
    vim.o.operatorfunc = "v:lua.ReplaceWithRegister"
    return "g@"
  end
  if (type ~= "char") then
    vim.notify("Multiline operation not supported");
    return;
  end

  local start = vim.api.nvim_buf_get_mark(0, "[")
  local stop = vim.api.nvim_buf_get_mark(0, "]")
  if (start[1] ~= stop[1]) then
    vim.notify("Multiline operation not supported");
    return;
  end
  local line = vim.api.nvim_get_current_line()
  local new = vim.fn.getreg(_reg)
  if (string.find(new, "\n")) then
    vim.notify("Multiline operation not supported");
    return;
  end
  line = line:sub(1, start[2]) .. new .. line:sub(stop[2] + 2, -1)
  vim.api.nvim_set_current_line(line)
end

keymap("n", "gr", "v:lua.ReplaceWithRegister(\"\", \"\")", { noremap = true, expr = true })
keymap("n", "<leader>gr", "v:lua.ReplaceWithRegister(\"\", \"+\")", { noremap = true, expr = true })

keymap("n", "<F7>", '', { noremap = true, callback = require("user.utils").highlight_log })

-- Remove help key (to close to escape
keymap("n", "<F1>", '', {})

keymap("n", "<leader> ", ":Ex<CR>", opts)
