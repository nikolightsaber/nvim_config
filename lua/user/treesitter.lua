local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  print'Error! No Treesitter'
  return;
end

-- Install with TSInstall <name_lang>
treesitter.setup {
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}

require('user.treesitter-context')
