-- Anguarls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#angularls
-- install
-- npm install -g @angular/language-server
-- local node_modules need language server installed

local function get_angular_cmd(root_dir)
  local project_root = vim.fs.find("node_modules", { path = root_dir, upward = true })[1]

  local default_probe_dir = project_root and (project_root .. "/node_modules") or ""

  return {
    "npx",
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    default_probe_dir,
    "--ngProbeLocations",
    default_probe_dir,
  }
end

return {
  cmd = get_angular_cmd(),
  on_new_config = function(new_config, _)
    new_config.cmd = get_angular_cmd()
  end,
  filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
  root_markers = { 'angular.json', '.git' },
}
