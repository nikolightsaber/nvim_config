return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  keys = { "<leader>", "g", "z=" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          n = { ["<Up>"] = function() end, ["<Down>"] = function() end },
          i = { ["<Up>"] = function() end, ["<Down>"] = function() end, ["<C-y>"] = require("telescope.actions").select_default },
        }
      }
    })

    vim.lsp.handlers["textDocument/references"] = function() require("telescope.builtin").lsp_references({ path_display = { "truncate" } }) end
    vim.lsp.handlers["textDocument/definition"] = function() require("telescope.builtin").lsp_definitions({ path_display = { "truncate" } }) end

    local files = function()
      return require("telescope.builtin").find_files({ previewer = false, path_display = { "absolute" }, no_ignore = true })
    end

    local grep_live = function()
      return require("telescope.builtin").live_grep({ path_display = { "truncate" } })
    end

    local buffers = function()
      return require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false, path_display = { "absolute" } }))
    end

    local current_word = function()
      local word = vim.fn.expand("<cword>")
      vim.fn.setreg("/", word, "c")
      vim.o.hlsearch = true
      return require("telescope.builtin").grep_string({
        prompt_title = "Search selection",
        search = word,
        path_display = { "truncate" },
      })
    end

    local grep_current_file = function()
      return require("telescope.builtin").current_buffer_fuzzy_find({ path_display = { "hidden" } })
    end

    local help_tags = function()
      return require("telescope.builtin").help_tags({ path_display = { "tail" } })
    end

    vim.keymap.set("n", "<leader>f", files)
    vim.keymap.set("n", "<leader>g", grep_live)
    vim.keymap.set("n", "<leader>/", grep_current_file)
    vim.keymap.set("n", "<leader>sh", help_tags)
    vim.keymap.set("n", "<leader>b", buffers)
    vim.keymap.set("n", "<leader>tr", require("telescope.builtin").resume)
    vim.keymap.set("n", "z=", require("telescope.builtin").spell_suggest)
    vim.keymap.set("n", "gt", current_word)
  end,
}
