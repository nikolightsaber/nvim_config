local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  print("no gitsigns")
  return
end

gitsigns.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
    delay = 0,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
}
vim.api.nvim_set_keymap("n", "<leader>w", "", { noremap = true, callback = function () require('gitsigns.actions').blame_line({ full = true, ignore_whitespace = true }) end})
vim.api.nvim_set_keymap("n", "<leader>ts", "", { noremap = true, callback= require('gitsigns.actions').toggle_signs })
vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg="#6c7993" })
vim.api.nvim_set_keymap("n", "<leader>tb", "", { noremap = true, callback= require('gitsigns.actions').toggle_current_line_blame })
vim.api.nvim_set_keymap("n", "<leader>jh", "", { noremap = true, callback = require('gitsigns.actions').next_hunk })
vim.api.nvim_set_keymap("n", "<leader>kh", "", { noremap = true, callback = require('gitsigns.actions').prev_hunk })
