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

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
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

  if atribute ~= "Fact" and atribute ~= "Theory" and atribute ~= "TestMethod" then
    return nil
  end

  return require("user.utils").get_ts_text(method:field("name")[1])
end

local build_and_debug_curr_cs_test_file = function()
  local buf = vim.fn.bufname()
  local dir = vim.fs.dirname(buf)
  local proj = vim.fs.dirname(vim.fs.find(function(name)
    return name:match("%.csproj$")
  end, { path = dir, upward = true, type = "file", limit = 2 })[1])

  local pid = nil ---@type number?

  local cmd = { "dotnet", "test", "-c", "Debug", proj, "--environment=VSTEST_HOST_DEBUG=1" };

  local test_name = get_cs_test_name_if_test()
  print("Starting test on " .. proj .. " and test " .. (test_name or "whole file"))
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
          -- dap.run({
          --   type = "gdb",
          --   name = "launch - gdb",
          --   request = "attach",
          --   pid = pid,
          -- })
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
local run_cs_proj = function(args)
  local buf = vim.fn.bufname()
  local dir = vim.fs.dirname(buf)
  local proj = vim.fs.dirname(vim.fs.find(function(name)
    return name:match("%.csproj$")
  end, { path = dir, upward = true, type = "file", limit = 1 })[1])

  local cmd = { "dotnet", "run", "-c", "Debug", "--project", proj, args.args };
  print("Starting run on " .. proj)
  local obj = vim.system(cmd, {})
  local ppid = obj.pid
  vim.schedule(function()
    local pid = nil
    while not pid do
      local v = vim.api.nvim_get_proc_children(ppid)
      local projname = vim.fs.basename(proj)
      for _, child_pid in ipairs(v) do
        local child = vim.api.nvim_get_proc(child_pid)
        if projname:sub(1, #child.name) == child.name then
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


---@return string?
local get_cs_csproj_pid = function()
  local buf = vim.fn.bufname()
  local dir = vim.fs.dirname(buf)
  local proj = vim.fs.basename(vim.fs.find(function(name)
    return name:match("%.csproj$")
  end, { path = dir, upward = true, type = "file", limit = 1 })[1])

  local cmd = { "pgrep", proj:sub(1, 15)};
  print("Searching for " .. proj)
  local obj = vim.system(cmd, {}):wait(100);
  if obj.code ~= 0 then
    print("Process not found " .. obj.code .. " " .. obj.stdout)
    return nil
  end
  return obj.stdout
end

local attach_cs_proj = function()
  local pid = get_cs_csproj_pid()
  if not pid then
    return
  end
  print("DapStarting " .. pid)
  dap.run({
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "attach",
    processId = pid,
  })
end

local attach_cs_proj_gdb = function()
  local buf = vim.fn.bufname()
  local dir = vim.fs.dirname(buf)
  local proj = vim.fs.basename(vim.fs.find(function(name)
    return name:match("%.csproj$")
  end, { path = dir, upward = true, type = "file", limit = 1 })[1])

  local cmd = { "pgrep", proj:sub(1, 15)};
  print("Searching for " .. proj)
  local obj = vim.system(cmd, {}):wait(100);
  if obj.code ~= 0 then
    print("Process not found " .. obj.code .. " " .. obj.stdout)
    return
  end
  local pid = obj.stdout
  print("DapStarting " .. pid)
  dap.run({
    type = "gdb",
    name = "attach - gdb",
    request = "attach",
    pid = tonumber(pid),
  })
end

vim.api.nvim_create_user_command("RunCsProj", run_cs_proj, {
  nargs = "*",
  complete = function(_, _)
  end,
})

vim.api.nvim_create_user_command("AttachCsProj", attach_cs_proj, {
  nargs = "*",
  complete = function(_, _)
  end,
})
vim.api.nvim_create_user_command("AttachCsProjGDB", attach_cs_proj_gdb, {
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
vim.keymap.set('n', '<Leader>di', function()
  local widgets = require('dap.ui.widgets')
  widgets.sidebar(widgets.sessions, { width = 50 }, "belowright vsplit").open()
end)
vim.keymap.set('n', '<Leader>dt', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.threads)
end)
