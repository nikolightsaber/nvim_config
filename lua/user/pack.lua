vim.pack.add({
  { name = 'tokyonight',        src = 'https://github.com/folke/tokyonight.nvim' },
  { name = 'telescope',         src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { name = 'plenary',           src = 'https://github.com/nvim-lua/plenary.nvim' },
  { name = 'nvim-web-devicons', src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { name = 'lazydev',           src = 'https://github.com/folke/lazydev.nvim' },
  { name = 'harpoon',           src = 'https://github.com/ThePrimeagen/harpoon',         version = "harpoon2" },
  { name = 'treesitter',        src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { name = 'treesitter-context',        src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
}, { load = true })

vim.cmd.colorscheme('tokyonight-storm')

require("telescope").setup({
  defaults = {
    mappings = {
      n = { ["<Up>"] = function() end, ["<Down>"] = function() end },
      i = { ["<Up>"] = function() end, ["<Down>"] = function() end, ["<C-y>"] = require("telescope.actions").select_default },
    }
  }
})
vim.keymap.set("n", "<leader>f",
  function() require("telescope.builtin").find_files({ previewer = false, path_display = { "absolute" }, no_ignore = true }) end)
vim.keymap.set("n", "<leader>g", function() require("telescope.builtin").live_grep({ path_display = { "truncate" } }) end)
vim.keymap.set("n", "<leader>/",
  function() require("telescope.builtin").current_buffer_fuzzy_find({ path_display = { "hidden" } }) end)
vim.keymap.set("n", "<leader>sh", function() require("telescope.builtin").help_tags({ path_display = { "tail" } }) end)
vim.keymap.set("n", "<leader>b",
  function() require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false, path_display = { "absolute" } })) end)
vim.keymap.set("n", "<leader>tr", function() require("telescope.builtin").resume() end)
vim.keymap.set("n", "z=", function() require("telescope.builtin").spell_suggest() end)
vim.keymap.set("n", "gt", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", word, "c")
  vim.o.hlsearch = true
  return require("telescope.builtin").grep_string({ prompt_title = "Search selection", search = word, path_display = { "truncate" }, })
end)


require("harpoon"):setup({ settings = { save_on_toggle = true, } })

vim.keymap.set("n", "<leader>a", function() require("harpoon"):list():add() end)
vim.keymap.set("n", "<C-h>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end)
vim.keymap.set("n", "<C-j>", function() require("harpoon"):list():select(1) end)
vim.keymap.set("n", "<C-k>", function() require("harpoon"):list():select(2) end)
vim.keymap.set("n", "<C-l>", function() require("harpoon"):list():select(3) end)
vim.keymap.set("n", "<C-;>", function() require("harpoon"):list():select(4) end)
vim.keymap.set("n", "<C-'>", function() require("harpoon"):list():select(5) end)
vim.keymap.set("n", "<C-\\>", function() require("harpoon"):list():select(6) end)

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})
