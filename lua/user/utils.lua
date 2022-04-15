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
  local status_ok, playground = pcall(require, 'nvim-treesitter-playground.hl-info')
  if not status_ok then
    return ""
  end
  local highlight = ""
  local weight = 0
  for _, v in ipairs(playground.get_treesitter_hl()) do
    local _,w,hl = unpack(require("user.utils").split(v, "->"))
    if tonumber(w) > weight then
      weight = tonumber(w)
      highlight = hl:gsub("*", ""):gsub(" ", "")
    end
  end
  return highlight
end

M.get_word_under_cursor = function()
  return vim.fn.expand("<cword>")
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
    call sign_define("minus", { "linehl" : "RemoveTask"})
    while search(' \~ MainTask', 'W') > 0
        let line = line('.')
        call sign_place(1, '', 'minus', @%, {'lnum' : line})
    endwhile
  ]]
  return ""
end

M.test_data= function()
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

return M
