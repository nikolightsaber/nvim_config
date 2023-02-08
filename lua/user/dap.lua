local dap_status, dap = pcall(require, "dap")

if not dap_status then
  print("dap not working")
end

vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
vim.keymap.set('n', '<F12>', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

dap.adapters.coreclr = {
  type = "executable",
  command = "/home/nikolai/code/github/netcoredbg/build/src/netcoredbg",
  args = {"--interpreter=vscode"}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

local M = {}

M.pattern_run_debug = function ()
  dap.run({
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = vim.fn.getcwd() .. "/Apps/BR.PatternCmdline/bin/Debug/net6.0/BR.PatternCmdline.dll",
    args = { "pattern", "Apps/BR.Mower.BasicUnitTests/PatternGenerator/patterninputfile_golfnaxhelet549.txt", "out.txt" },
  })
end

return M
