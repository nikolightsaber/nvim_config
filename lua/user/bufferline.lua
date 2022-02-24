local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  print('Error! No Bufferline')
  return
end
bufferline.setup({
  options = {
    max_name_length = 30,
    max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
    tab_size = 21,
    diagnostics = false, -- | "nvim_lsp" | "coc",
    diagnostics_update_in_insert = false,

    offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = false,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist

    name_formatter = function(buf)
      if(buf.name:len() > 15) then
        return buf.name:sub(buf.name:len() - 15)
      end
    end,

    separator_style = "slant", -- | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = true,
    always_show_bufferline = true,
  },
  highlight = {
    background = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    fill = {
      guifg = { attribute = "fg", highlight = "#ff0000" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
  },
})
