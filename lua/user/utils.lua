M = {};

---@param line string
---@param i integer
---@param char string
---@param hi string
local highlight_line = function(line, i, match, hi)
  local s, _, _ = string.find(line, match, 1, true)
  if (s ~= nil) then
    vim.api.nvim_buf_add_highlight(0, -1, hi, i, 0, -1)
  end
end

M.highlight_log = function()
  vim.cmd.setfiletype("messages")
  vim.api.nvim_set_hl(0, "AddTask", { fg = "#00CD00" })
  vim.api.nvim_set_hl(0, "RemoveTask", { fg = "#CD0000" })
  vim.api.nvim_set_hl(0, "AddAsyncTask", { fg = "#CDCD00" })
  vim.api.nvim_set_hl(0, "SuspendTask", { fg = "#FF0000" })
  local lines = vim.api.nvim_buf_line_count(0)
  for i = 0, lines - 1 do
    local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)
    highlight_line(line[1], i, " + MainTask ->", "AddTask")
    highlight_line(line[1], i, " - MainTask ->", "RemoveTask")
    highlight_line(line[1], i, " +A MainTask ->", "AddAsyncTask")
    highlight_line(line[1], i, " ~ MainTask ->", "SuspendTask")
  end
end

M.current_repo = function()
  local current_dir = vim.split(vim.fn.getcwd(), "/")
  return current_dir[#current_dir]
end

local current_git_branch = nil;

M.current_branch = function()
  if current_git_branch then
    return current_git_branch
  end

  local f_head = io.open("./.git/HEAD")
  if f_head then
    local HEAD = f_head:read()
    f_head:close()
    local branch = HEAD:match("ref: refs/heads/(.+)$")
    if branch then
      current_git_branch = branch
    end
    return current_git_branch
  end
  return nil
end

M.dotnet_build_diag = function()
  print("Build Start")
  vim.fn.jobstart({ "dotnet", "build", "Libraries/BR.Mower/", "-o", "bin", "--nologo", "-v", "q" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local errors = {}
      for _, x in pairs(data) do
        local error_split = require("user.utils").split(x, ":")
        if #error_split == 3 then
          if string.find(x, "error") then
            local path_split = require("user.utils").split(error_split[1], "(")
            if vim.uri_from_fname(path_split[1]) == vim.uri_from_bufnr(0) then
              local line_split = require("user.utils").split(path_split[2], ",")
              table.insert(errors, {
                bufnr = 0,
                lnum = tonumber(line_split[1]) - 1,
                col = tonumber(line_split[2]:sub(1, -2)) - 1,
                severity = vim.diagnostic.severity.ERROR,
                source = "dotnet build",
                message = error_split[2] .. ": " .. require("user.utils").split(error_split[3], "[")[1]
              })
            end
          end
        elseif string.find(x, "Build") then
          break
        end
      end
      vim.diagnostic.set(vim.api.nvim_create_namespace("DotNet Build"), 0, errors, {})
      if (#errors == 0) then
        print("Done: Succes !")
      else
        print("Done: Fail !")
      end
    end,
  })
end

return M
