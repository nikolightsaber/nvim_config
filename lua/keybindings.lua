vim.api.nvim_set_keymap("n", "<Enter>", "o<Esc>", {})

vim.api.nvim_set_keymap("n", "n", "nzz", {})
vim.api.nvim_set_keymap("n", "N", "Nzz", {})
vim.api.nvim_set_keymap("n", "*", "*zz", {})

vim.api.nvim_set_keymap("n", "<C-PageUp>", ":bp<CR>", {})
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":bn<CR>", {})

vim.api.nvim_set_keymap("n", "<F5>", ":setlocal spell! spelllang=en_us<CR>", {})
vim.api.nvim_set_keymap("n", "<F6>", ":setlocal spell! spelllang=nl<CR>", {})

vim.api.nvim_set_keymap("v", "//", "y/\\V<C-R>=escape(@\",\'/\\\')<CR><CR>", {})
