-- CSHARP_LS
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#csharp_ls
-- normal install
-- dotnet tool install --global csharp-ls

local cmd = { 'csharp-ls' }
if vim.uv.fs_stat("BR.Navigation.Linux.sln") then
  cmd = { "csharp-ls", "--solution", "BR.Navigation.Linux.sln" }
end

---@type vim.lsp.Config
return {
  cmd = cmd,
  init_options = {
    AutomaticWorkspaceInit = true,
  },
  filetypes = { 'cs' },
  root_dir = function(bufnr, cb)
    -- prefer sln as root dir
    local dir =
        vim.fs.root(bufnr, function(file) return file:match("%.sln$") ~= nil end) or
        vim.fs.root(bufnr, function(file) return file:match("%.csproj$") ~= nil end)

    if dir then
      cb(dir)
    end
  end,
}
