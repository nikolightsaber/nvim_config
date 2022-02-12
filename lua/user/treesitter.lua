status_ok, treesitter = pcall('require', 'nvim-treesitter.configs')
if not status_ok then
    return;
end

-- Install with TSInstall <name_lang>
treesitter.setup {
    highlight = {
        enable = true,
    },
}
