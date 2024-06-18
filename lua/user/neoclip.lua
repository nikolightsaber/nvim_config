return {
  "AckslD/nvim-neoclip.lua",
  lazy = true,
  keys = { "<leader><Enter>", "y" },
  config = function()
    require("neoclip").setup({ default_register = { "+", "\"" } })
    local telescope = require("telescope")
    pcall(telescope.load_extension, "neoclip")
    vim.keymap.set("n", "<leader><Enter>",
      function() return telescope.extensions.neoclip.neoclip({ initial_mode = "normal" }) end)
  end,
}
