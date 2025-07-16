vim.pack.add({
  { name = 'tokyonight',         src = 'https://github.com/folke/tokyonight.nvim' },
  { name = 'telescope',          src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { name = 'plenary',            src = 'https://github.com/nvim-lua/plenary.nvim' },
  { name = 'nvim-web-devicons',  src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { name = 'harpoon',            src = 'https://github.com/ThePrimeagen/harpoon',                     version = 'harpoon2' },
  { name = 'treesitter',         src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { name = 'treesitter-context', src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  { name = 'gitsigns',           src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { name = 'dap',                src = 'https://github.com/mfussenegger/nvim-dap' },
  { name = 'render-markdown',    src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
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

require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "▶" },
    topdelete = { text = "▶" },
    changedelete = { text = "▎" },
  },
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "right_align",
    delay = 0,
    ignore_whitespace = false,
  },
  preview_config = { border = "rounded" },
})

vim.keymap.set("n", "<leader>w", function()
  local actions = require("gitsigns").get_actions() or {}
  local blame_line = actions["blame_line"]
  if (blame_line ~= nil) then
    blame_line({ full = true, ignore_whitespace = true })
    return;
  end
  local preview_hunk = actions["preview_hunk"]
  if (preview_hunk ~= nil) then
    preview_hunk({ full = true, ignore_whitespace = true })
  end
end
)
vim.keymap.set("n", "<leader>tb", function() require("gitsigns.actions").toggle_current_line_blame() end)
vim.keymap.set("n", "]h", function() require("gitsigns.actions").nav_hunk("next") end)
vim.keymap.set("n", "[h", function() require("gitsigns.actions").nav_hunk("prev") end)

require("user.dap")
