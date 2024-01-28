local status, harpoon = pcall(require, "harpoon")
if not status then
  vim.notify("No Harpoon")
  return
end

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-'>", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<C-\\>", function() harpoon:list():select(6) end)
