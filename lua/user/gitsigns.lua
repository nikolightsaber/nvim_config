return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      signs = {
        add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "▶", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "▶", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
        delay = 0,
        ignore_whitespace = false,
      },
    })

    local blame_or_preview = function()
      local actions = gitsigns.get_actions()
      local blame_line = actions["blame_line"]
      if (blame_line ~= nil) then
        blame_line({ full = true, ignore_whitespace = true })
      end

      local preview_hunk = actions["preview_hunk"]
      if (preview_hunk ~= nil) then
        preview_hunk({ full = true, ignore_whitespace = true })
      end
    end

    vim.keymap.set("n", "<leader>w", blame_or_preview)
    vim.keymap.set("n", "<leader>ts", require('gitsigns.actions').toggle_signs)
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#6c7993" })
    vim.keymap.set("n", "<leader>tb", require('gitsigns.actions').toggle_current_line_blame)
    vim.keymap.set("n", "<leader>jh", function() require('gitsigns.actions').nav_hunk("next") end)
    vim.keymap.set("n", "<leader>kh", function() require('gitsigns.actions').nav_hunk("prev") end)
  end
}
