-- no files to add
if #arg <= 2 then
  return
end
local user = arg[1]
local pid = arg[2]
if not user or not pid or pid == "" then
  return;
end
print(vim.inspect(arg))
local pipe = "/run/user/" .. user .. "/nvim." .. pid .. ".0"
print(pipe)
local chan = vim.fn.sockconnect("pipe", pipe, { rpc = true });
for i = 3, #arg, 1 do
  vim.rpcrequest(chan, "nvim_input", ":e " .. arg[i] .. "<CR>");
end
-- mynvim()
-- {
--     NVIM_PID=`pgrep nvim -P $$ | xargs pgrep -P 2>/dev/null`
--     if [ -n "$NVIM_PID" ]; then
--         nvim -l "$HOME/.config/nvim/lua/onesession.lua" `id -u` $NVIM_PID $@
--         JOBS=`jobs -p`
--         fg %1
--     else
--         nvim $@;
--     fi
-- }
