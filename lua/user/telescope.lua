return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  keys = {
    { "<leader>f",  function() require("telescope.builtin").find_files({ previewer = false, path_display = { "absolute" }, no_ignore = true }) end },
    { "<leader>g",  function() require("telescope.builtin").live_grep({ path_display = { "truncate" } }) end },
    { "<leader>/",  function() require("telescope.builtin").current_buffer_fuzzy_find({ path_display = { "hidden" } }) end },
    { "<leader>sh", function() require("telescope.builtin").help_tags({ path_display = { "tail" } }) end },
    { "<leader>b",  function() require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false, path_display = { "absolute" } })) end },
    { "<leader>tr", function() require("telescope.builtin").resume() end },
    { "z=",         function() require("telescope.builtin").spell_suggest() end },
    {
      "gt",
      function()
        local word = vim.fn.expand("<cword>")
        vim.fn.setreg("/", word, "c")
        vim.o.hlsearch = true
        return require("telescope.builtin").grep_string({
          prompt_title = "Search selection",
          search = word,
          path_display = { "truncate" },
        })
      end
    },
  },
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
  end,
}
