return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  keys = { "<leader>", "g", "z=" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        mappings = {
          n = { ["<Up>"] = function() end, ["<Down>"] = function() end },
          i = { ["<Up>"] = function() end, ["<Down>"] = function() end, ["<C-y>"] = require("telescope.actions").select_default },
        }
      }
    })

    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")

    vim.lsp.handlers["textDocument/references"] = function() builtin.lsp_references({ path_display = { "truncate" } }) end
    vim.lsp.handlers["textDocument/definition"] = function() builtin.lsp_definitions({ path_display = { "truncate" } }) end

    local files = function()
      local opts = { previewer = false, path_display = { "absolute" }, no_ignore = true }
      return builtin.find_files(opts)
    end

    local grep_live = function()
      return builtin.live_grep({ path_display = { "truncate" } })
    end

    local grep_word = function(word)
      vim.fn.setreg("/", word, "c")
      vim.o.hlsearch = true
      return builtin.grep_string({
        prompt_title = "Search selection",
        search = word,
        path_display = { "truncate" },
      })
    end

    local buffers = function()
      return builtin.buffers(themes.get_dropdown({ previewer = false, path_display = { "absolute" } }))
    end
    local current_word = function()
      local word = vim.fn.expand("<cword>")
      return grep_word(word)
    end

    local current_word_visual = function()
      local word = vim.fn.getreg("x")
      return grep_word(word)
    end

    local grep_current_file = function()
      return builtin.current_buffer_fuzzy_find({ path_display = { "hidden" } })
    end

    local help_tags = function()
      return builtin.help_tags({ path_display = { "tail" } })
    end

    vim.keymap.set("n", "<leader>f", files)
    vim.keymap.set("n", "<leader>g", grep_live)
    vim.keymap.set("n", "<leader>/", grep_current_file)
    vim.keymap.set("n", "<leader>sh", help_tags)
    vim.keymap.set("n", "<leader>b", buffers)
    vim.keymap.set("n", "<leader>tr", builtin.resume)
    vim.keymap.set("n", "z=", builtin.spell_suggest)
    vim.keymap.set("n", "gt", current_word)
    vim.keymap.set("v", "gt", current_word_visual)
  end,
}
