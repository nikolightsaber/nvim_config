local status, formatter = pcall(require, "formatter")
if not status then
  return;
end

formatter.setup({
  filetype = {
    rust = require("formatter.filetypes.rust").rustfmt
  }
})

