M = {};
M.split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end


M.get_highlight = function()
  local status_ok, playground = pcall(require, 'nvim-treesitter-playground.utils')
  if not status_ok then
    return ""
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = vim.api.nvim_win_get_cursor(0)
  row = row - 1
  local results = playground.get_hl_groups_at_position(bufnr, row, col)
  if(#results > 0) then
    return results[#results].general
  else
    return ""
  end
end

M.dump = function (o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. M.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

M.highlight_log = function()
  vim.cmd[[
    set syntax=messages
    hi AddTask guifg=#00CD00
    hi RemoveTask guifg=#CD0000
    hi AddAsyncTask guifg=#CDCD00
    hi SuspendTask guifg=#FF0000
    normal gg
    call sign_define("plus", { "linehl" : "AddTask"})
    while search(" + MainTask", 'W') > 0
        let line = line('.')
        call sign_place(1, '', 'plus', @%, {'lnum' : line})
    endwhile
    normal gg
    call sign_define("async", { "linehl" : "AddAsyncTask"})
    while search(" +A MainTask", 'W') > 0
        let line = line('.')
        call sign_place(1, '', 'async', @%, {'lnum' : line})
    endwhile
    normal gg
    call sign_define("susp", { "linehl" : "SuspendTask"})
    while search(' \~ MainTask', 'W') > 0
        let line = line('.')
        call sign_place(1, '', 'susp', @%, {'lnum' : line})
    endwhile
    normal gg
    call sign_define("minus", { "linehl" : "RemoveTask"})
    while search(' - MainTask', 'W') > 0
        let line = line('.')
        call sign_place(1, '', 'minus', @%, {'lnum' : line})
    endwhile
  ]]
  return ""
end

M.test_data = function()
  vim.cmd[[
    while search("data name=", 'W') > 0
        let l = line('.')
        normal 3w*
        if l != line('.')
            echo l
            normal datn
        endif
    endwhile
  ]]
  return ""
end

M.current_repo = function()
  local current_dir = require("user.utils").split(vim.fn.getcwd(), "/")
  return current_dir[#current_dir]
end

M.dotnet_build_diag =  function ()
  print("Build Start")
  vim.fn.jobstart({ "dotnet", "build", "Libraries/BR.Mower/", "-o", "bin", "--nologo", "-v", "q" }, {
    stdout_buffered = true,
    on_stdout = function (_, data)
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
                col = tonumber(line_split[2]:sub(1,-2)) - 1,
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
