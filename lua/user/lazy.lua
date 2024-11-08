local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "folke/lazydev.nvim",
    lazy = true,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end },
      { "<C-h>",     function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end },
      { "<C-j>",     function() require("harpoon"):list():select(1) end },
      { "<C-k>",     function() require("harpoon"):list():select(2) end },
      { "<C-l>",     function() require("harpoon"):list():select(3) end },
      { "<C-;>",     function() require("harpoon"):list():select(4) end },
      { "<C-'>",     function() require("harpoon"):list():select(5) end },
      { "<C-\\>",    function() require("harpoon"):list():select(6) end },
    },
    opts = { settings = { save_on_toggle = true, } },
  },
  {
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
        "gt", function()
        local word = vim.fn.expand("<cword>")
        vim.fn.setreg("/", word, "c")
        vim.o.hlsearch = true
        return require("telescope.builtin").grep_string({ prompt_title = "Search selection", search = word, path_display = { "truncate" }, })
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
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>w", function()
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
      },
      { "<leader>tb", function() require('gitsigns.actions').toggle_current_line_blame() end },
      { "]h",         function() require('gitsigns.actions').nav_hunk("next") end },
      { "[h",         function() require('gitsigns.actions').nav_hunk("prev") end },
    },
    opts = {
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
    }
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      require("user.lsp").setup()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    lazy = true,
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "light"
    end
  },
}, {
  ui = { border = "rounded", },
})
