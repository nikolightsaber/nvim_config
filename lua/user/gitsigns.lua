return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = function ()
    require("gitsigns").setup({
      signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
        delay = 0,
        ignore_whitespace = false,
      },
    })
    vim.keymap.set("n", "<leader>w", function () require('gitsigns.actions').blame_line({ full = true, ignore_whitespace = true }) end)
    vim.keymap.set("n", "<leader>ts", require('gitsigns.actions').toggle_signs )
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg="#6c7993" })
    vim.keymap.set("n", "<leader>tb", require('gitsigns.actions').toggle_current_line_blame )
    vim.keymap.set("n", "<leader>jh", require('gitsigns.actions').next_hunk )
    vim.keymap.set("n", "<leader>kh", require('gitsigns.actions').prev_hunk )
  end
}
