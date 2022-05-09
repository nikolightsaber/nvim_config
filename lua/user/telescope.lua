M = {}
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  print("telescope not working")
  return M
end

local actions = require "telescope.actions"
local builtin = require "telescope.builtin"
local themes = require "telescope.themes"

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
    layout_config = {
      horizontal = {
        height = 0.95,
        width = 0.95,
        preview_width = 0.7,
      }
    }
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

local files = function()
  set_path_mode("absolute")
  local current_repo =require("user.utils").current_repo()
  local opts = { previewer = false }
  if current_repo == "navigation" then
    opts.no_ignore = true
  end
  builtin.find_files(opts)
  return ""
end

local grep_live = function()
  set_path_mode("truncate")
  builtin.live_grep()
  return ""
end

local grep_word = function(word)
  vim.fn.setreg("/", word, "c")
  vim.o.hlsearch = true
  set_path_mode("truncate")
  builtin.grep_string({
    prompt_title = 'Search selection',
    search = word,
  })
  return ""
end

local buffers = function()
  set_path_mode("absolute")
  builtin.buffers(themes.get_dropdown({ previewer = false }))
  return ""
end

M.references = function()
  set_path_mode("tail")
  builtin.lsp_references()
  return ""
end

M.definitions = function()
  set_path_mode("tail")
  builtin.lsp_definitions()
  return ""
end

local current_word = function ()
  local word = vim.fn.expand("<cword>")
  return grep_word(word)
end

M.current_word_visual = function ()
  local word = vim.fn.getreg("x")
  return grep_word(word)
end

local grep_current_file = function ()
  set_path_mode("hidden")
  return builtin.live_grep({ search_dirs={vim.api.nvim_buf_get_name(0) } })
end

vim.api.nvim_set_keymap("n", "<leader>f", "", { noremap = true, callback = files })
vim.api.nvim_set_keymap("n", "<leader>g", "", { noremap = true, callback = grep_live })
vim.api.nvim_set_keymap("n", "<leader>b", "", { noremap = true, callback = buffers })
vim.api.nvim_set_keymap("n", "<leader>/", "", { noremap = true, callback = grep_current_file })
vim.api.nvim_set_keymap("n", "gt", "", { noremap = true, callback = current_word })
vim.api.nvim_set_keymap("v", "gt", '"xy<cmd>lua require("user.telescope").current_word_visual()<cr>', { noremap = true })

return M
