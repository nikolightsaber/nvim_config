local colorscheme = "dracula"
-- colorscheme = "tokyonight"
-- colorscheme = "tokyodark"
colorscheme = "gruvbox-baby"
require('rose-pine').setup({ dark_variant = "moon" })
-- colorscheme = "rose-pine"
vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_highlights = {Search = {fg = "Black", bg = "Orange", style="underline"}}

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2f3243" })
-- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
