local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("No nvim tree");
  return
end

vim.api.nvim_set_keymap("n", "<leader> ", "<cmd>NvimTreeFindFileToggle<cr>", { noremap = true })

nvim_tree.setup()
