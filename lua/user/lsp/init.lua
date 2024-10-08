M = {}

--- @param client (vim.lsp.Client)
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

--- @param bufnr (number)
local function lsp_keymaps(bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "", { noremap = true, callback = vim.lsp.buf.declaration })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "", { noremap = true, callback = vim.lsp.buf.definition })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "", { noremap = true, callback = vim.lsp.buf.implementation })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", "", { noremap = true, callback = vim.diagnostic.open_float })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>th", "",
    { noremap = true, callback = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end })
end

--- @param client (vim.lsp.Client)
--- @param bufnr (number)
M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
  vim.lsp.completion.enable(true, client.id, bufnr, {
    autotrigger = true,
    -- convert = function(item)
    --   vim.notify(vim.inspect(item), vim.log.levels.WARN)
    --   return item
    -- end
  });
  -- vim.api.nvim_create_autocmd("CompleteChanged",
  --   {
  --     group = vim.api.nvim_create_augroup("testttt", { clear = true }),
  --     callback = function()
  --       if vim.tbl_isempty(vim.v.event.completed_item) then return end
  --       local e = vim.v.event;
  --       local item = vim.v.event.completed_item;
  --       local params = item.user_data.nvim.lsp.completion_item;
  --       if vim.tbl_isempty(params) then return end
  --       local cancel_fun = client.request('completionItem/resolve', params,
  --         function(err, result)
  --           local doc = result.documentation.value
  --           if doc then
  --             e.completed_item.info = doc
  --           end
  --         end, vim.api.nvim_get_current_buf())
  --     end
  --   })
end

--- @param client (vim.lsp.Client)
--- @param bufnr (number)
M.on_attach_format = function(client, bufnr)
  M.on_attach(client, bufnr)
  local group = vim.api.nvim_create_augroup("lsp_formatter", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost",
    {
      group = group,
      callback = function() vim.lsp.buf.format() end
    })
end

M.setup = function()
  local cwd = vim.fn.getcwd() or "";
  if string.find(cwd, "nvim") ~= nil then
    require("lazydev").setup({ integrations = { cmp = false } })
  end
  require("user.lsp.servers")

  local config = {
    virtual_text = false,
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
    signs = {
      text = {
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.ERROR] = "",
      }
    }
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  require("lspconfig.ui.windows").default_options.border = "rounded";

  -- lazy therefore start
  vim.cmd.LspStart();
end

return M
