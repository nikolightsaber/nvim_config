local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback
vim.api.nvim_set_keymap("n", "<leader> ", "<cmd>NvimTreeFindFileToggle<cr>", { noremap = true })

nvim_tree.setup()
