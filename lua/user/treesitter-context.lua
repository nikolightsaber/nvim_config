local ts_context_status_ok, ts_context = pcall(require, "treesitter-context")
if not ts_context_status_ok then
  return
end
ts_context.setup({
  enable = true,
})


vim.api.nvim_set_keymap("n", "<leader>tc", "<cmd>TSContextToggle<CR>", { noremap = true })
