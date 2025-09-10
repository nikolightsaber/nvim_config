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

---@return string?
local get_cs_test_name_if_test = function()
  local method = require("user.utils").get_ts_ansestor("method_declaration")
  if not method then
    return nil
  end
  local first_child = method:child(0)
  if not first_child or first_child:type() ~= "attribute_list" then
    return nil
  end
  local atribute = require("user.utils").get_ts_text(first_child:named_child(0))

  if atribute ~= "Fact" and atribute ~= "Theory" then
    return nil
  end

  return require("user.utils").get_ts_text(method:field("name")[1])
end

local build_and_debug_curr_cs_test_file = function()
  local buf = vim.fn.bufname()
  local dir = vim.fs.dirname(buf)
  local pid = nil ---@type number?

  local cmd = { "dotnet", "test", "-c", "Debug", dir, "--environment=VSTEST_HOST_DEBUG=1" };

  local test_name = get_cs_test_name_if_test()
  print("Starting test on " .. dir .. " and test " .. (test_name or "whole file"))
  if test_name then
    table.insert(cmd, #cmd + 1, "--filter");
    table.insert(cmd, #cmd + 1, test_name);
  end
  vim.system(cmd, {
    stdout = function(err, line)
      if err ~= nil or line == nil then
        return
      end
      if pid then
        return
      end
      local match = string.match(line, "Process Id: (%d+)")
      if match then
        pid = tonumber(match)
        vim.schedule(function()
          print("DapStarting " .. pid)
          dap.run({
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "attach",
            processId = pid,
          })
        end)
      end
    end
  })
end

vim.api.nvim_create_user_command("DebugCurrentCSTestFile", build_and_debug_curr_cs_test_file, {
  nargs = "*",
  complete = function(_, _)
  end,
})

---@param args vim.api.keyset.create_user_command.command_args
local runsim = function(args)
  local buf = vim.fn.bufname()
  local dir = vim.fs.dirname(buf)
  local proj = vim.fs.basename(vim.fs.find(function(name)
    return name:match("%.csproj$")
  end, { path = dir, upward = true, type = "file", limit = 1 })[1])

  local cmd = { "dotnet", "run", "-c", "Debug", "--project", dir, args.args };
  local obj = vim.system(cmd, { })
  local ppid = obj.pid
  vim.schedule(function()
    local pid = nil
    while not pid do
      local v = vim.api.nvim_get_proc_children(ppid)
      for _, child_pid in ipairs(v) do
        local child = vim.api.nvim_get_proc(child_pid)
        if proj:sub(1, #child.name) == child.name then
          pid = child.pid
        end
      end
    end
    print("DapStarting " .. pid)
    dap.run({
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "attach",
      processId = pid,
    })
  end)
end

vim.api.nvim_create_user_command("DebugSimCs", runsim, {
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
