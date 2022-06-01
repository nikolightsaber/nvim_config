return {
  settings = {

    Lua = {
      diagnostics = {
        globals = { "vim", "use" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$HOME/.local/share/nvim/site/pack/packer")] = true,
          [vim.fn.expand("/usr/share/awesome/lib")] = true,
        },
      },
    },
  },
}
