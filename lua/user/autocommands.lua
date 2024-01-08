local set_2_tab = function()
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2
  vim.o.softtabstop = 2
end

local group = vim.api.nvim_create_augroup("2indet", { clear=true })
vim.api.nvim_create_autocmd("FileType", { group=group, pattern={ "lua", "typescript" ,"html", "css" }, callback=set_2_tab })


local set_tabexpand_off = function()
  vim.o.expandtab = false
end

group = vim.api.nvim_create_augroup("tabexpand", { clear=true })
vim.api.nvim_create_autocmd("BufEnter", { group=group, pattern={ "odintomqtt.c", "brsysglue.sh", "rc.main", "rc.ublox" }, callback=set_tabexpand_off })

local format_safe= function ()
  local status, _ = pcall(require, "formatter")
  if not status then
    return
  end
  vim.cmd.FormatWrite()
end
group = vim.api.nvim_create_augroup("rustfmt", { clear=true })
vim.api.nvim_create_autocmd("BufWritePost", { group=group, pattern={ "*.rs" }, callback=format_safe })

group = vim.api.nvim_create_augroup("prettier", { clear=true })
vim.api.nvim_create_autocmd("BufWritePost", { group=group, pattern={ "*/cockpit-app/*.ts" }, callback=format_safe })

local set_spel = function ()
  vim.b.wrap = true
  vim.o.spell = true
end

group = vim.api.nvim_create_augroup("spell", { clear=true })
vim.api.nvim_create_autocmd("FileType", { group=group, pattern={ "gitcommit", "latex", "markdown" }, callback=set_spel })

vim.cmd [[
  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  " Show trailing whitespace and spaces before a tab:
  match ExtraWhitespace /\s\+$\| \+\ze\t/
  " Show tabs that are not at the start of a line:
  match ExtraWhitespace /[^\t]\zs\t\+/
  " Show trailing whitespaces when not in insert mode:
]]

group = vim.api.nvim_create_augroup("whitespace", { clear=true })
vim.api.nvim_create_autocmd("ColorScheme", { group=group, pattern="*", command=[[highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen]] })
vim.api.nvim_create_autocmd("InsertEnter", { group=group, pattern="*", command=[[match ExtraWhitespace /\s\+\%#\@<!$/]] })
vim.api.nvim_create_autocmd("InsertLeave", { group=group, pattern="*", command=[[match ExtraWhitespace /\s\+$/]] })

group = vim.api.nvim_create_augroup("yankhighlight", { clear=true })
vim.api.nvim_create_autocmd("TextYankPost", { group=group, callback = function() vim.highlight.on_yank({ hlgroup = "Visual", timeout = 200 }) end })
