-- NetCoreDbg
-- https://github.com/Samsung/netcoredbg
-- INSTALL
--~/.local/share/nvim/dap_servers
-- clone, build, ln to .local/bin
-- For build use cmake and clang
-- do everything in build direcory
-- ln -s /home/nikolai/code/github/netcoredbg/build/src/netcoredbg /home/nikolai/.local/bin/
local dap = require("dap");
dap.adapters.coreclr = {
  type = "executable",
  command = "netcoredbg",
  args = { "--interpreter=vscode" }
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

---@param dir string
local start_deubgging_cs_proj = function(dir)
  local dirs = vim.split(dir, "/")
  local dirname = dirs[#dirs]
  local dlls = vim.fs.find(dirname .. ".dll", { path = dir .. "/bin/Debug/net6.0/" })
  if #dlls ~= 1 then
    print("No DLL found")
    return
  end
  local dll = dlls[1]

  print("Starting test on " .. dll)
  local pid = nil ---@type number?
  vim.system({ "dotnet", "test", dll, "--environment=VSTEST_HOST_DEBUG=1" }, {
    stdout = function(err, line)
      if err ~= nil or line == nil then
        return
      end
      local match = string.match(line, "Process Id: (%d+)")
      if match then
        pid = tonumber(match)
      end
    end
  })

  vim.schedule(function()
    while pid == nil do
      vim.cmd.sleep("10m")
    end
    print("Starting debugger")
    dap.run({
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "attach",
      processId = pid,
    })
  end)
end

local build_and_debug_curr_cs_test_file = function()
  local buf = vim.fn.bufname()
  local dir = vim.fs.dirname(buf)
  print("Building  " .. dir)
  vim.system({ "dotnet", "build", dir }, {}, function()
    start_deubgging_cs_proj(dir)
  end)
end

vim.api.nvim_create_user_command("DebugCurrentCSTestFile", build_and_debug_curr_cs_test_file, {
  nargs = "*",
  complete = function(_, _)
  end,
})

vim.keymap.set("n", "<F5>", function() dap.continue() end)
vim.keymap.set("n", "<F10>", function() dap.step_over() end)
vim.keymap.set("n", "<F11>", function() dap.step_into() end)
vim.keymap.set("n", "<F12>", function() dap.step_out() end)
vim.keymap.set("n", "<Leader>dc", function() dap.run_to_cursor() end)
vim.keymap.set("n", "<Leader>dbn", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<Leader>dbc", function() dap.toggle_breakpoint(vim.fn.input("Condition: ")) end)
vim.keymap.set("n", "<Leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
vim.keymap.set("n", "<Leader>dr", function() dap.repl.open() end)
vim.keymap.set("n", "<Leader>dl", function() dap.run_last() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.sidebar(widgets.scopes, { width = 120 }, "belowright vsplit").open()
end)
