local colorscheme = "dracula"
-- colorscheme = "tokyonight"
-- colorscheme = "tokyodark"
require('rose-pine').setup({ dark_variant = "moon" })
colorscheme = "rose-pine"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2f3243" })
-- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
