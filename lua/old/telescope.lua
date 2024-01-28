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
      only_sort_text = true,
    }
  },
}

require('user.telescope-extentions')

local undo_status, telescope_undo = pcall(require, "telescope-undo.actions")
if undo_status then
  local undo = {
    extensions = {
      undo = {
        use_delta = true,     -- this is the default
        side_by_side = false, -- this is the default
        mappings = {          -- this whole table is the default
          i = {
            -- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
            -- you want to use the following actions. This means installing as a dependency of
            -- telescope in it's `requirements` and loading this extension from there instead of
            -- having the separate plugin definition as outlined above. See issue #6.
            ["<cr>"] = telescope_undo.yank_additions,
            ["<S-cr>"] = telescope_undo.yank_deletions,
            ["<C-cr>"] = telescope_undo.restore,
          },
        },
      },
    },
  }
  vim.tbl_deep_extend("force", setup, undo)
end

telescope.setup(setup)

local files = function()
  local current_repo = require("user.utils").current_repo()
  local opts = { previewer = false, path_display = { "absolute" }, no_ignore = false }
  if current_repo == "navigation" or current_repo == "dupnavi" then
    opts.no_ignore = true
  end
  return builtin.find_files(opts)
end

local grep_live = function()
  return builtin.live_grep( { path_display = { "truncate" } })
end

local grep_word = function(word)
  vim.fn.setreg("/", word, "c")
  vim.o.hlsearch = true
  return builtin.grep_string({
    prompt_title = 'Search selection',
    search = word,
    path_display = { "truncate" },
  })
end

local buffers = function()
  return builtin.buffers(themes.get_dropdown({ previewer = false, path_display = { "absolute" } }))
end

M.references = function()
  return builtin.lsp_references({ path_display = { "tail" } })
end

M.definitions = function()
  return builtin.lsp_definitions({ path_display = { "tail" } })
end

local current_word = function ()
  local word = vim.fn.expand("<cword>")
  return grep_word(word)
end

local current_word_visual = function ()
  local word = vim.fn.getreg("x")
  return grep_word(word)
end

local grep_current_file = function ()
  return builtin.current_buffer_fuzzy_find({ path_display = { "hidden" } })
end

local help_tags = function ()
  return builtin.help_tags({ path_display = { "tail" } })
end

vim.api.nvim_set_keymap("n", "<leader>f", "", { noremap = true, callback = files })
vim.api.nvim_set_keymap("n", "<leader>g", "", { noremap = true, callback = grep_live })
vim.api.nvim_set_keymap("n", "<leader>/", "", { noremap = true, callback = grep_current_file })
vim.api.nvim_set_keymap("n", "<leader>sh", "", { noremap = true, callback = help_tags })
vim.api.nvim_set_keymap("n", "<leader>b", "", { noremap = true, callback = buffers })
vim.api.nvim_set_keymap("n", "<leader>tr", "", { noremap = true, callback = builtin.resume })
vim.api.nvim_set_keymap("n", "z=", "", { noremap = true, callback = builtin.spell_suggest })
vim.api.nvim_set_keymap("n", "gt", "", { noremap = true, callback = current_word })
vim.api.nvim_set_keymap("v", "gt", "", { noremap = true, callback = current_word_visual})

return M
