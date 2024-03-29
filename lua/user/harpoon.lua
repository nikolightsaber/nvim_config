return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        key = function()
          local cwd = vim.fn.getcwd()
          local branch = require("user.utils").current_branch()
          if branch then
            return cwd .. ":" .. branch;
          end
          return cwd
        end,
      }
    })

    vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
    vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)
    vim.keymap.set("n", "<C-'>", function() harpoon:list():select(5) end)
    vim.keymap.set("n", "<C-\\>", function() harpoon:list():select(6) end)
  end,
}
