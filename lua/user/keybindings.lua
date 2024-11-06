local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<Enter>", "o<Esc>")

keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")
-- Don't go to next one yet
keymap("n", "*", "*Nzz")

keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

keymap("n", "<C-PageUp>", ":bp<CR>")
keymap("n", "<C-PageDown>", ":bn<CR>")

keymap("n", "<F6>", ":setlocal spell! spelllang=en_us<CR>")
--keymap("n", "<F6>", ":setlocal spell! spelllang=nl<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>")
keymap("n", "<C-Down>", ":resize -2<CR>")
keymap("n", "<C-Left>", ":vertical resize -2<CR>")
keymap("n", "<C-Right>", ":vertical resize +2<CR>")

keymap("v", "//", "y/\\V<C-R>=escape(@\",\'/\\\')<CR><CR>")

-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

keymap("v", "p", '"_dP')

-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv=gv")
keymap("x", "K", ":move '<-2<CR>gv=gv")

-- stop scrolling
keymap("n", "<Up>", "")
keymap("n", "<Down>", "")

keymap("n", "<F1>", "")

function _G.ReplaceWithRegister(type)
  if (type == "") then
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
  local new = vim.fn.getreg("+")
  if (string.find(new, "\n")) then
    vim.notify("Multiline operation not supported");
    return;
  end
  line = line:sub(1, start[2]) .. new .. line:sub(stop[2] + 2, -1)
  vim.api.nvim_set_current_line(line)
end

keymap("n", "gr", "v:lua.ReplaceWithRegister(\"\")", { expr = true })

keymap("n", "<F7>", require("user.utils").highlight_log)

keymap("n", "<leader> ", ":Ex<CR>")
