local colorscheme = "dracula"
-- colorscheme = "tokyonight"
-- colorscheme = "tokyodark"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2f3243"})
