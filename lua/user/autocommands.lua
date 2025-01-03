local set_2_tab = function()
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2
  vim.o.softtabstop = 2
end

local group = vim.api.nvim_create_augroup("2indet", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  { group = group, pattern = { "lua", "typescript", "html", "css" }, callback = set_2_tab })


local set_spel = function()
  vim.b.wrap = true
  vim.o.spell = true
end

group = vim.api.nvim_create_augroup("spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "latex", "markdown" },
  callback = set_spel
})

group = vim.api.nvim_create_augroup("yankhighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost",
  { group = group, callback = function() vim.highlight.on_yank({ hlgroup = "Visual", timeout = 200 }) end })

vim.api.nvim_create_autocmd("BufWritePost",
  {
    group = vim.api.nvim_create_augroup("formatter", { clear = true }),
    pattern = { "*/cockpit-app/*.ts", "*/cockpit-app/*.html", "*/cockpit-app/*.css", "*/cockpit-app/*.css" },
    callback = function()
      vim.fn.jobstart({ "npx", "prettier", "--write", vim.api.nvim_buf_get_name(0) }, {
        stdout_buffered = true,
        on_exit = function(_, _)
          vim.schedule(vim.cmd.edit);
        end
      })
    end,
  })
