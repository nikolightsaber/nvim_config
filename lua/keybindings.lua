local opts = { noremap = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<Enter>", "o<Esc>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)

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

local count = 0
function _G.Inc()
    count = count + 1
    print(count)
    return ""
end

function _G.Dec()
    count = count - 1
    print(count)
    return ""
end

function _G.Res()
    count = 0
    print(count)
    return ""
end

keymap("n", "<A-PageUp>", "v:lua.Inc()", { noremap = true, expr = true })
keymap("n", "<A-PageDown>", "v:lua.Dec()", { noremap = true, expr = true })
keymap("n", "<A-\\>", "v:lua.Res()", { noremap = true, expr = true })

