local status_ok, neoclip = pcall(require, "neoclip")

if not status_ok then
  print("Error no neoclip")
  return
end

neoclip.setup({
  history = 1000,
  enable_persistent_history = false,
  db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
  filter = nil,
  preview = true,
  default_register = '+',
  default_register_macros = 'q',
  enable_macro_history = true,
  content_spec_column = false,
  on_paste = {
    set_reg = false,
  },
  on_replay = {
    set_reg = false,
  },
  keys = {
    telescope = {
      i = {
        move_selection_next = "<C-j>",
        move_selection_previous = "<C-k>",
        select = '<cr>',
        paste = '<c-p>',
        paste_behind = '<c-o>',
        replay = '<c-q>',
        custom = {},
      },
      n = {
        select = '<cr>',
        paste = 'p',
        paste_behind = 'P',
        replay = 'q',
        custom = {},
      },
    },
  },
})

local status, telescope = pcall(require, "telescope")
if not status then
  return
end
telescope.load_extension("neoclip")
telescope.load_extension("undo")

vim.api.nvim_set_keymap("n", "<c-p>", "", {noremap = true,
                                           callback = function () return telescope.extensions.neoclip.neoclip({initial_mode="normal"}) end })
vim.api.nvim_set_keymap("n", "<leader>u", "", { noremap = true, callback = telescope.extensions.undo.undo })
