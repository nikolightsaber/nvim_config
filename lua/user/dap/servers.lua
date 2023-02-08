local dap_status, dap = pcall(require, "dap")

if not dap_status then
  print("dap not working")
  return
end

--------------------------------------------------------------------------
-- NetCoreDbg
dap.adapters.coreclr = {
  type = "executable",
  command = "/home/nikolai/code/github/netcoredbg/build/src/netcoredbg",
  args = {"--interpreter=vscode"}
}

-- C#
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

--------------------------------------------------------------------------
-- Custom setups
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
