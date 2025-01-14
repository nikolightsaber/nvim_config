M = {}

--- @param client (vim.lsp.Client)
--- @param bufnr (number)
local function lsp_highlight_document(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.document_highlight
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.clear_references
    })

    local list = { "LspReferenceText", "LspReferenceRead", "LspReferenceWrite" }
    for _, hi in ipairs(list) do
      vim.api.nvim_set_hl(0, hi, { bold = true })
    end
  end
end

--- @param t (vim.lsp.LocationOpts.OnList)
local function on_list_telescope(t)
  if #t.items == 1 then
    local item = t.items[1]
    local b = item.bufnr or vim.fn.bufadd(item.filename)
    vim.cmd("normal! m'")
    vim.bo[b].buflisted = true
    vim.api.nvim_win_set_buf(0, b)
    vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
    return
  end
  local opts = {}
  require("telescope.pickers")
      .new(opts, {
        finder = require("telescope.finders").new_table({
          results = t.items,
          entry_maker = require("telescope.make_entry").gen_from_quickfix(opts),
        }),
        previewer = require("telescope.config").values.qflist_previewer(opts),
        sorter = require("telescope.config").values.generic_sorter(opts),
        push_cursor_on_edit = true,
        push_tagstack_on_edit = true,
        prompt_title = t.title,
      })
      :find()
end

--- @param bufnr (number)
local function lsp_keymaps(bufnr)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, { buffer = bufnr })
  vim.keymap.set("i", "<C-s>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, { buffer = bufnr })
  vim.keymap.set("n", "grr", function() vim.lsp.buf.references(nil, { on_list = on_list_telescope }) end,
    { buffer = bufnr })
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition({ on_list = on_list_telescope }) end, { buffer = bufnr })
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = bufnr })
  vim.keymap.set("n", "<leader>th", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
    { buffer = bufnr })
end

--- @param client (vim.lsp.Client)
--- @param bufnr (number)
local function lsp_completion_info(client, bufnr)
  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true, })

  local compl_info_req_id = nil
  vim.api.nvim_create_autocmd("CompleteChanged", {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup("completion_info", { clear = true }),
    callback = function()
      local compl_item = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
      if not compl_item then
        return
      end
      if compl_info_req_id then
        print("canceling")
        client:cancel_request(compl_info_req_id)
      end

      local id = vim.fn.complete_info({ "selected" }).selected
      _, compl_info_req_id = client:request("completionItem/resolve", compl_item,
        function(err, result)
          compl_info_req_id = nil
          if err or not result then
            return
          end
          local doc = vim.tbl_get(result, "documentation", "value")
          if not doc then
            return
          end

          local mark = vim.lsp.util.convert_input_to_markdown_lines(doc)
          local ret = vim.api.nvim__complete_set(id,
            { info = table.concat(vim.lsp.util._normalize_markdown(mark), '\n') })
          if not ret.bufnr or
              not ret.winid or
              not vim.api.nvim_buf_is_valid(ret.bufnr) or
              not vim.api.nvim_win_is_valid(ret.winid) then
            return
          end
          vim.bo[ret.bufnr].filetype = "markdown"
          vim.bo[ret.bufnr].bufhidden = "wipe"
          vim.wo[ret.winid].spell = false
          vim.wo[ret.winid].foldenable = false
          vim.wo[ret.winid].breakindent = true
          vim.wo[ret.winid].smoothscroll = true
          vim.wo[ret.winid].conceallevel = 2
          vim.treesitter.start(ret.bufnr)
          vim.api.nvim_win_set_config(ret.winid, { border = "rounded" })
        end,
        vim.api.nvim_get_current_buf())
    end
  })
end

--- @param client (vim.lsp.Client)
--- @param bufnr (number)
M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client, bufnr)
  lsp_completion_info(client, bufnr)
end

--- @param client (vim.lsp.Client)
--- @param bufnr (number)
local function lsp_format(client, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup("lsp_formatter", { clear = true }),
    callback = function() vim.lsp.buf.format({ bufnr = bufnr, id = client.id }) end
  })
end

--- @param client (vim.lsp.Client)
--- @param bufnr (number)
M.on_attach_format = function(client, bufnr)
  M.on_attach(client, bufnr)
  lsp_format(client, bufnr)
end

M.setup = function()
  local cwd = (vim.fn.getcwd() or "") .. "/" .. (vim.fn.bufname() or "")
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

  -- lazy therefore start
  vim.cmd.LspStart()
end

return M
