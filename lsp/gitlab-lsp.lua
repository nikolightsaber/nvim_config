-- GITLAB-LSP
-- https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp
-- install:
-- Download genreric package from registry
-- extract in /share/nvim/lsp_servers/gitlab-lsp
-- in ~/.local/bin
-- ln -s ../share/nvim/lsp_servers/gitlab-lsp/gitlab-lsp-linux-x64 gitlab-lsp

local settings = {
  baseUrl = 'https://gitlab.com',
  codeCompletion = {
    enableSecretRedaction = true,
  },
  telemetry = {
    enabled = false,
    trackingUrl = nil,
  },
}
return {
  cmd = { "gitlab-lsp", "--stdio" },
  handlers = {
    ['$/gitlab/token/check'] = function(_err, result, _ctx, _config)
      local message
      if result and result.message then
        message = 'gitlab.vim: ' .. result.message
      else
        message = 'gitlab.vim: Unexpected error from LSP server: ' .. vim.inspect(result)
      end

      print(message, vim.log.levels.ERROR)
    end,
    ['$/gitlab/featureStateChange'] = function(_err, result)
      -- local checks_passed = true
      -- local feature_states = result and result[1]
      -- for _, feature_state in ipairs(feature_states) do
      --   lsp.refresh_feature(feature_state.featureId, feature_state)
      --   if feature_state.engagedChecks and #feature_state.engagedChecks > 0 then
      --     checks_passed = false
      --   end
      -- end
      --
      -- if checks_passed then
      --   statusline.update_status_line(globals.GCS_AVAILABLE)
      -- else
      --   statusline.update_status_line(globals.GCS_UNAVAILABLE)
      -- end
    end,
    ['textDocument/completion'] = function(_err, result)
    end
  },
  root_dir = vim.fn.getcwd(),
  settings = settings,
  --- @param client vim.lsp.Client
  on_init = function(client, _)
    client.offset_encoding = 'utf-16'

    local new_settings = vim.deepcopy(settings)
    new_settings.token = vim.env.GITLAB_TOKEN
    -- print("token " .. vim.env.GITLAB_TOKEN)

    client:notify('workspace/didChangeConfiguration', {
      settings = new_settings,
    })
  end,
}
