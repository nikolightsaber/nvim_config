M = {};

---@param line string
---@param i integer
---@param match string
---@param ns integer
---@param hi string
local highlight_line = function(line, i, match, ns, hi)
  local s, _, _ = string.find(line, match, 1, true)
  if (s ~= nil) then
    vim.hl.range(0, ns, hi, { i, 0 }, { i, -1 })
  end
end

M.highlight_log = function()
  vim.cmd.setfiletype("messages")
  vim.api.nvim_set_hl(0, "AddTask", { fg = "#00CD00" })
  vim.api.nvim_set_hl(0, "RemoveTask", { fg = "#CD0000" })
  vim.api.nvim_set_hl(0, "AddAsyncTask", { fg = "#CDCD00" })
  vim.api.nvim_set_hl(0, "SuspendTask", { fg = "#FF0000" })
  local lines = vim.api.nvim_buf_line_count(0)
  local ns = vim.api.nvim_create_namespace("tasktree")
  for i = 0, lines - 1 do
    local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)
    highlight_line(line[1], i, " + MainTask ->", ns, "AddTask")
    highlight_line(line[1], i, " - MainTask ->", ns, "RemoveTask")
    highlight_line(line[1], i, " +A MainTask ->", ns, "AddAsyncTask")
    highlight_line(line[1], i, " ~ MainTask ->", ns, "SuspendTask")
  end
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

---@param type string
---@return TSNode?
M.get_ts_ansestor = function(type)
  local node = vim.treesitter.get_node()
  while node ~= nil and node:type() ~= type do
    node = node:parent()
  end
  return node
end

---@param node TSNode?
---@return string?
M.get_ts_text = function(node)
  if not node then
    return nil
  end
  return vim.treesitter.get_node_text(node, 0)
end

return M
