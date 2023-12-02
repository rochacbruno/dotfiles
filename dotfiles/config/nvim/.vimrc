" Enable line numbers
set number
set relativenumber
set colorcolumn=80

set clipboard=unnamedplus

" Enable syntax highlighting
syntax enable

" Enable auto-indentation and expand tabs to spaces
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4

" Enable line wrapping
set wrap

" Set the color scheme to something unique
colorscheme darkblue

:autocmd InsertEnter,InsertLeave * set cul!

" Change line numbers to relative in Normal mode
augroup NumberingMode
  autocmd!
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
augroup END

" Neovim specific config
if has('nvim')

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=900}
augroup END

endif
