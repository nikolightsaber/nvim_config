local opts = { noremap = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<Enter>", "o<Esc>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)

keymap("n", "<C-PageUp>", ":bp<CR>", opts)
keymap("n", "<C-PageDown>", ":bn<CR>", opts)

vim.api.nvim_set_keymap("v", "//", "y/\\V<C-R>=escape(@\",\'/\\\')<CR><CR>", {})
