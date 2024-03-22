return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    sections = {
      lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },
      lualine_b = { { "branch", icons_enabled = true, icon = "", } },
      lualine_c = { { 'filename', file_status = true, path = 1 } },
      lualine_x = {
        function() return "spaces: " .. vim.api.nvim_get_option_value("shiftwidth", {}) end,
        "encoding",
        { "filetype", icon_only = true, }
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { 'filename', file_status = true, path = 1 } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
  },
}
