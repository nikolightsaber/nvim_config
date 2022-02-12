require'nvim-treesitter.configs'
local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
    print'Error! No Treesitter'
    return;
end

-- Install with TSInstall <name_lang>
treesitter.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
