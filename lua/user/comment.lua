local status_ok, comment = pcall(require, 'Comment')
if not status_ok then
  print('Error! No comment')
  return
end

comment.setup({
  padding = true,
  sticky = true,
  ignore = nil,

  toggler = {
    line = 'gcc',
    block = 'gbc',
  },
  ---LHS of operator-pending mappings in NORMAL + VISUAL mode
  ---@type table
  opleader = {
    ---Line-comment keymap
    line = 'gc',
    ---Block-comment keymap
    block = 'gb',
  },

  mappings = {
    basic = true,
    extra = false,
    extended = false,
  },
  pre_hook = nil,
  post_hook = nil,
})

