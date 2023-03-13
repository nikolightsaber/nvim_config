local dap_status, dap = pcall(require, "dap")

if not dap_status then
  print("dap not working")
  return
end

--------------------------------------------------------------------------
-- NetCoreDbg
-- https://github.com/Samsung/netcoredbg
-- INSTALL
-- clone, build, ln to .local/bin
-- For build use cmake and clang
-- do everything in build direcory
-- ln -s /home/nikolai/code/github/netcoredbg/build/src/netcoredbg /home/nikolai/.local/bin/
dap.adapters.coreclr = {
  type = "executable",
  command = "netcoredbg",
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

local pattern_run_debug = function (pattern)
  dap.run({
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = vim.fn.getcwd() .. "/Apps/BR.PatternCmdline/bin/Debug/net6.0/BR.PatternCmdline.dll",
    args = { "patternwithgraph", pattern, "out.txt" },
  })
end

local last_pattern = "Apps/BR.Mower.BasicUnitTests/PatternGenerator/patterninputfile_multipleoverlaps.txt";
local debug_navigation = function (_)
  -- vim.fn.jobstart({ "dotnet", "build", "Libraries/BR.Mower/", "-o", "bin", "--nologo", "-v", "q" })
  pattern_run_debug(last_pattern)
end
vim.api.nvim_create_user_command("DebugPatternCmdline", debug_navigation, {
  nargs="*",
  complete = function(_, line)
  end,
})
