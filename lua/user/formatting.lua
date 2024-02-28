return {
  "mhartington/formatter.nvim",
  ft = { "ts", "html", "css" },
  event = "BufWritePre",
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
