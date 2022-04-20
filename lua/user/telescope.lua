M = {}
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  print("telescope not working")
  return M
end

local actions = require "telescope.actions"

local setup = {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "absolute" },

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    live_grep = {
      only_sort_text = true
    }
  },
}
telescope.setup(setup)

local path_mode = "absolute"

local set_path_mode = function(mode)
  if(mode ~= path_mode)then
    path_mode = mode
    setup.defaults.path_display = { path_mode }
    telescope.setup(setup)
  end
end

M.files = function()
  set_path_mode("absolute")
  local current_repo =require("user.utils").current_repo()
  local opts = { previewer = false }
  if current_repo == "navigation" then
    opts.no_ignore = true
  end
  require('telescope.builtin').find_files(opts)
  return ""
end

M.grep_live = function()
  set_path_mode("truncate")
  require('telescope.builtin').live_grep()
  return ""
end

M.grep_word = function(word)
  vim.fn.setreg("/", word, "c")
  vim.o.hlsearch = true
  set_path_mode("truncate")
  require('telescope.builtin').grep_string({
    prompt_title = 'Search selection',
    search = word,
  })
  return ""
end

M.buffers = function()
  set_path_mode("absolute")
  require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))
  return ""
end

M.references = function()
  set_path_mode("tail")
  require('telescope.builtin').lsp_references()
  return ""
end

M.definitions = function()
  set_path_mode("tail")
  require('telescope.builtin').lsp_definitions()
  return ""
end

M.current_word = function ()
  local word = vim.fn.expand("<cword>")
  return require('user.telescope').grep_word(word)
end

M.current_word_visual = function ()
  local word = vim.fn.getreg("x")
  return require('user.telescope').grep_word(word)
end

M.grep_current_file = function ()
  set_path_mode("hidden")
  return require('telescope.builtin').live_grep({ search_dirs={vim.api.nvim_buf_get_name(0) } })
end

vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua require('user.telescope').files()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua require('user.telescope').grep_live()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua require('user.telescope').buffers()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>/", "<cmd>lua require('user.telescope').grep_current_file()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "gt", "<cmd>lua require('user.telescope').current_word()<cr>", { noremap = true })
vim.api.nvim_set_keymap("v", "gt", '"xy<cmd>lua require("user.telescope").current_word_visual()<cr>', { noremap = true })

return M
