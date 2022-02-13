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


M.get_higlight = function()
    local status_ok, playground = pcall(require, 'nvim-treesitter-playground.hl-info')
    if not status_ok then
        return ""
    end
    local highlight = ""
    local weight = 0
    for _, v in ipairs(playground.get_treesitter_hl()) do
        local _,w,hl = unpack(M.split(v, "->"))
        if tonumber(w) > weight then
            weight = tonumber(w)
            highlight = hl:gsub("*", ""):gsub(" ", "")
        end
    end
    return highlight
end

return M
