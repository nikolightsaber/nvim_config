local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  print("no which key")
  return
end

which_key.setup({
  window = {
    border = "rounded",
  }
})

local mappings = {
  K = "LSP Hover",
  g = {
    D = "LSP Go To Declaration",
    d = "LSP Go To Definition",
    i = "LSP Go To Implementation",
    r = "Replace with register",
    b = "Block comment",
    c = "Line comment",
    t = "Grep current word",
  },
  ["<leader>"] = {
    ["/"] = "Live Grep Current File",
    ["<space>"] = "File Browser",
    e = "LSP Show Error",
    f = "Search Files",
    g = "Live Grep",
    w = "GIT Blame",
    u = "Undo history",
    tr = "Resume telescope",
    sb = "Search Buffers",
    ts = "Toggle Signs",
    tb = "Toggle Blame Line",
    th = "Toggle Inlay Hints",
    tc = "Toggle Treesitter Context",
    ca = "LSP Code Actions",
    sh = "Search help",
    r = {
      f = "LSP See References",
      n = "LSP Rename",
    },
    j = {
      "Next Prefix",
      h = "Next Hunk",
      d = "Next Diagnostic",
    },
    k = {
      "Previous Prefix",
      h = "Previous Hunk",
      d = "Previous Diagnostic",
    },
    mir = "Make It Rain",
  }
}
which_key.register(mappings, {});
