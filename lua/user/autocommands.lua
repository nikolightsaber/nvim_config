vim.cmd [[
  augroup _2indet
    autocmd!
    autocmd FileType typescript,html lua require("user.options").set2tab()
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  " Show trailing whitespace and spaces before a tab:
  match ExtraWhitespace /\s\+$\| \+\ze\t/
  " Show tabs that are not at the start of a line:
  match ExtraWhitespace /[^\t]\zs\t\+/
  " Show trailing whitespaces when not in insert mode:
  au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match ExtraWhitespace /\s\+$/
]]
