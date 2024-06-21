return {
  "mhartington/formatter.nvim",
  lazy = true,
  event = "BufWritePre",
  cond = function()
    local files = { "ts", "css", "html" }
    local file = vim.filetype.match({ buf = 0 })
    return vim.list_contains(files, file);
  end,
  config = function()
    require("formatter").setup({
      filetype = {
        typescript = require("formatter.filetypes.typescript").prettier,
        html = require("formatter.filetypes.html").prettier,
        css = require("formatter.filetypes.css").prettier,
        scss = require("formatter.filetypes.css").prettier,
      }
    })

    local group = vim.api.nvim_create_augroup("formatter", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost",
      {
        group = group,
        pattern = { "*/cockpit-app/*.ts", "*/cockpit-app/*.html", "*/cockpit-app/*.css", "*/cockpit-app/*.css" },
        callback = function() vim.cmd.FormatWrite() end
      })
  end
}
