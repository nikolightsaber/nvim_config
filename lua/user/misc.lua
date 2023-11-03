local status, formatter, nvim_tree, hardtime, comment

status, formatter = pcall(require, "formatter")
if status then
  formatter.setup({
    filetype = {
      rust = require("formatter.filetypes.rust").rustfmt
    }
  })
end

status, nvim_tree = pcall(require, "nvim-tree")
if status then
  vim.api.nvim_set_keymap("n", "<leader> ", "<cmd>NvimTreeFindFileToggle<cr>", { noremap = true })
  nvim_tree.setup()
end

status, hardtime = pcall(require, "hardtime")
if status then
  hardtime.setup({ enabled = false })
end


status, comment = pcall(require, 'Comment')
if status then
  comment.setup()
end

