local M = {}

M.setup = function()
  local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  local status_ok, _ = pcall(require, "telescope.builtin")
  if status_ok then
    vim.lsp.handlers["textDocument/references"] = require('user.telescope').references
    vim.lsp.handlers["textDocument/definition"] = require('user.telescope').definitions
  end

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  -- info window Lspinfo
  local lspconfig_status, win = pcall(require, 'lspconfig.ui.windows')
  if lspconfig_status then
    local _default_opts = win.default_opts
    win.default_opts = function(options)
      local opts = _default_opts(options)
      opts.border = 'rounded'
      return opts
    end
  end
end

-- local document_highlight = function ()
  -- local hl = require("user.utils").get_highlight()
  -- if hl == "" then
  --   hl = "Normal"
  -- end
  -- local rgb = vim.api.nvim_get_hl_by_name(hl, true)
  -- local fg = rgb["foreground"]
  -- local bg = rgb["background"]
  -- local list = { "LspReferenceText", "LspReferenceRead", "LspReferenceWrite" }
  -- for _,hi in ipairs(list) do
  --   vim.api.nvim_set_hl(0, hi, { bold = true } )
  -- end
  -- vim.lsp.buf.document_highlight()
-- end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider == true then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear=true })
    vim.api.nvim_create_autocmd("CursorHold", { group=group, pattern="<buffer>", callback=vim.lsp.buf.document_highlight })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, { group=group, pattern="<buffer>", callback=vim.lsp.buf.clear_references })
    local list = { "LspReferenceText", "LspReferenceRead", "LspReferenceWrite" }
    for _,hi in ipairs(list) do
      vim.api.nvim_set_hl(0, hi, { bold = true } )
    end
  end
end

local function lsp_keymaps(bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "", { noremap = true, callback = vim.lsp.buf.declaration })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "", { noremap = true, callback = vim.lsp.buf.definition })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "", { noremap = true, callback = vim.lsp.buf.hover })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "", { noremap = true, callback = vim.lsp.buf.implementation })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "", { noremap = true, callback = vim.lsp.buf.signature_help })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "", { noremap = true, callback = vim.lsp.buf.rename })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rf", "", { noremap = true, callback = vim.lsp.buf.references })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "", { noremap = true, callback = vim.lsp.buf.code_action })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", "", { noremap = true, callback = vim.diagnostic.open_float })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>jd", "", { noremap = true, callback = vim.diagnostic.goto_next })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>kd", "", { noremap = true, callback = vim.diagnostic.goto_prev })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>th", "", { noremap = true, callback = function () vim.lsp.buf.inlay_hint(bufnr) end })
end

M.on_attach = function(client, bufnr)
  -- if client.name == "tsserver" then
  -- client.resolved_capabilities.document_formatting = true
  -- end
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
  M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

return M
