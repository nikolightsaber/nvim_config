M = {}

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold",
      { group = group, pattern = "<buffer>", callback = vim.lsp.buf.document_highlight })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" },
      { group = group, pattern = "<buffer>", callback = vim.lsp.buf.clear_references })
    local list = { "LspReferenceText", "LspReferenceRead", "LspReferenceWrite" }
    for _, hi in ipairs(list) do
      vim.api.nvim_set_hl(0, hi, { bold = true })
    end
  end
end

local function lsp_keymaps(bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "", { noremap = true, callback = vim.lsp.buf.declaration })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "", { noremap = true, callback = vim.lsp.buf.definition })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "", { noremap = true, callback = vim.lsp.buf.hover })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "", { noremap = true, callback = vim.lsp.buf.implementation })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "", { noremap = true, callback = vim.lsp.buf.rename })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rf", "", { noremap = true, callback = vim.lsp.buf.references })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "", { noremap = true, callback = vim.lsp.buf.code_action })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", "", { noremap = true, callback = vim.diagnostic.open_float })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>jd", "", { noremap = true, callback = vim.diagnostic.goto_next })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>kd", "", { noremap = true, callback = vim.diagnostic.goto_prev })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>th", "",
    { noremap = true, callback = function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0)) end })
end

M.on_attach = function(client, bufnr)
  -- if client.name == "tsserver" then
  -- client.resolved_capabilities.document_formatting = true
  -- end
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
  if client.server_capabilities.documentFormattingProvider then
    local group = vim.api.nvim_create_augroup("lsp_formatter", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost",
      {
        group = group,
        callback = function() vim.lsp.buf.format() end
      })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
  M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

return M
