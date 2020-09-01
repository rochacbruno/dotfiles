syntax on
filetype plugin indent on

set guicursor=
set number relativenumber
set ruler
" set nohlsearch
set hidden
set cursorline
set cursorcolumn
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set backspace=indent,eol,start
set hlsearch
set ignorecase
set fileformats=unix,dos,mac
set autoread
set nowritebackup

set splitbelow
set splitright

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set colorcolumn=80,100,120
highlight ColorColumn ctermbg=0 guibg=lightgrey
highlight Comment ctermfg=red

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Show tabs and spavces visually
set list
set listchars+=tab:>-,space:.

" Start Plugin Management
call plug#begin('~/.vim/plugged')

    " Show colors
    "Plug 'gko/vim-coloresque'
    Plug 'chrisbra/Colorizer'

    "Multi cursor
    " C-N select words, C-move add cur, Shift move single char, n/N Next/Prev
    " [] next/prev cur, q skip, Q remove cursor
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}

    " Markdown editing and preview
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

    " Highlight and hints (little annoying)
    Plug 'gabrielelana/vim-markdown'
    " Soft or Hard Word Wrapping
    Plug 'reedes/vim-pencil'
    " Distraction free
    Plug 'junegunn/goyo.vim'

    " Align tables
    Plug 'godlygeek/tabular'

    "Auto Complete and Language Server
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Git integration
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb' " required by fugitive to :Gbrowse
    Plug 'airblade/vim-gitgutter'
    Plug 'rhysd/git-messenger.vim'

    " Useful commenting - gcc, gcap
    Plug 'tpope/vim-commentary'

    " Show latest changes and allow navigation
    Plug 'mbbill/undotree'

    " Object/AST tag bar
    Plug 'majutsushi/tagbar'

    " Linter
    Plug 'w0rp/ale'

    " Show the visual mark on indendation blocks ┆
    Plug 'Yggdroot/indentLine'

    " Syntax Highlighting
    Plug 'sheerun/vim-polyglot'

    " Rainbow match pairs
    Plug 'junegunn/rainbow_parentheses.vim'

    " Colorize the copied block
    Plug 'machakann/vim-highlightedyank'

    " Shows search counts
    Plug 'google/vim-searchindex'

    " Highlight word under cursor
    Plug 'RRethy/vim-illuminate'
    "Space-k highlight more worlds, n, N navigates, Space-K cleans it.
    Plug 'lfv89/vim-interestingwords'

    " Fade inactive buffers
    "Plug 'TaDaa/vimade'
    Plug 'blueyed/vim-diminactive'

    " Fuzzy Search :)
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
    " adds FZFMru
    Plug 'pbogut/fzf-mru.vim'

    " Alternative to fzf taht allows preview colorschemes `Clap colors`
    Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

    " Zoom! C-w-m (maximize)
    Plug 'dhruvasagar/vim-zoom'

    " Dispatch tasks to run async e.g: `:Dispatch PlugInstall`
    Plug 'tpope/vim-dispatch'

    " Allow repeating of plugin 3rd party actions
    Plug 'tpope/vim-repeat'

    " Manipulate surrounding chars such as quotes and brackets
    Plug 'tpope/vim-surround'

    " Beautiful Dark theme
    Plug 'gruvbox-community/gruvbox'

    " Hyped theme
    Plug 'dracula/vim', { 'as': 'dracula-vim' }

    " Auto Format
    Plug 'sbdchd/neoformat'

    " Interactive command execution
    let g:make = 'gmake'
    if exists('make')
            let g:make = 'make'
    endif
    Plug 'Shougo/vimproc.vim', {'do': g:make}

    "" Vim-Session
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-session'

    "" Snippets
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    "" Status and tab bar
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    "" Auto close/match brackets
    Plug 'Raimondi/delimitMate'

    "" A lot of colorschemes
    Plug 'flazz/vim-colorschemes'

    "" DEvicons for trees and bars
    Plug 'ryanoasis/vim-devicons'

    "" Python formatting
    Plug 'ambv/black'

    "" Do we need NERDTree?
    Plug 'preservim/nerdtree'

    "" Auto complete navigation with tab
    Plug 'ervandew/supertab'

    " ReplAuto python (does not work very nice but it is cool)
    Plug 'rhysd/reply.vim', { 'on': ['Repl', 'ReplAuto'] }

     "" SQL Stuff
    Plug 'tpope/vim-dadbod'
    " UI for Dadbod
    Plug 'kristijanhusak/vim-dadbod-ui'

    ""Move windows in a good way using C-w-hjkl
    Plug 'andymass/vim-tradewinds'

    " Command to show leader commands
    Plug 'derekprior/vim-leaders'

    " Extract variable: in visual mode, Alt =. name it, move it, ESC.
    Plug 'da-x/name-assign.vim'

    " Interact with output of commands e.g :Bufferize cargo watch
    Plug 'AndrewRadev/bufferize.vim'

    " Change one liners to multiple and vice-versa: gS (split a one liner) and gJ (join a block)
    Plug 'AndrewRadev/splitjoin.vim'

    " text moving (Select a text and A-hjkl)
    Plug 'matze/vim-move'

    " Provides :Rename, :Move, :Delete, :Chmod, :SudoEdit
    Plug 'tpope/vim-eunuch'

    " Delete instead of cut (cut is mapped to x, single char is  dl)
    Plug 'svermeulen/vim-cutlass'

    " HTML
    Plug 'mattn/emmet-vim'

    " Create gist with :Gist -c
    Plug 'mattn/gist-vim'
    Plug 'mattn/webapi-vim'

    " Make me dirs
    Plug 'pbrisbin/vim-mkdir'

    " Auto Completion from ZSH
    Plug 'tjdevries/coc-zsh'

    "Better repeatable f/t searching
    Plug 'rhysd/clever-f.vim'

    "`dsf`  deletes surrounding function `csf` change it
    Plug 'AndrewRadev/dsf.vim'

    " `cx` exchange 2 words `cxx` exchange 2 line
    Plug 'tommcdo/vim-exchange'

    " After a visual selection use + and - to expand it
    Plug 'landock/vim-expand-region'

    " Sets working dir
    Plug 'airblade/vim-rooter'

    "Scratch `gs`
    Plug 'mtth/scratch.vim'

    "i3 filetype
    Plug 'mboughaba/i3config.vim'

    " C-W-gsa creates a split above with the selection C-W-gss on right
    " CW-gr resizes to selection
    Plug 'wellle/visual-split.vim'

"" End of plugin management
call plug#end()

" where to save `gs` scratch?
let g:scratch_persistence_file = '~/vim_scratch.md'

" i3 file detection
aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.i3/config set filetype=i3config
aug end

"Visual split
xmap <C-W>gr  <Plug>(Visual-Split-VSResize)
xmap <C-W>gss <Plug>(Visual-Split-VSSplit)
xmap <C-W>gsa <Plug>(Visual-Split-VSSplitAbove)
xmap <C-W>gsb <Plug>(Visual-Split-VSSplitBelow)

"" Markdown options
" set to 1, nvim will open the preview window after entering the markdown buffer
let g:mkdp_auto_start = 0
" set to 1, the nvim will auto close current preview window when change
let g:mkdp_auto_close = 0


"" Apprearance
colorscheme gruvbox
set guifont=DroidSansMono\ Nerd\ Font\ 11
" This changes gruvbox bg to real dark
let g:gruvbox_contrast_dark = 'hard'
"" Theme improvements for embedded terminals
" if exists('+termguicolors')
"     let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"     let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" endif
let g:gruvbox_invert_selection='0'
set background=dark
" hi Normal guibg=NONE ctermbg=NONE
if has("gui_running")
    if has("gui_mac") || has("gui_macvim")
        set guifont=Menlo:h12
        set transparency=7
    endif
else
    let g:CSApprox_loaded = 1

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_faster = 1
endif


"" Session Management (Do I need  this?)
let g:session_directory = "~/.config/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1



"" Searching and Navigation

"" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" ripgrep
if executable('rg')
  let g:rg_derive_root='true'
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

let loaded_matchparen = 1
let mapleader = " "

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

" let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

let no_buffers_menu=1

" vim-airline
"let g:airline_theme = 'powerlineish'
"let g:airline_theme = 'base16_gruvbox_dark_hard'
"let g:airline_theme = 'minimalist'
let g:airline_theme = 'zenburn'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1


" Gist
let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1


"" Bindings

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

nnoremap <leader>u :UndotreeShow<CR>

"" I prefer NERDTree so I kept it here just as an example.
" nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" Get Help for Word
nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>
" Preview Refactor on Word
nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>
" Preview Search
nnoremap <Leader>ps :Rg<CR>
" Preview Search Word
nnoremap <leader>pw :Rg <C-R>=expand("<cword>")<CR><CR>
" Git Files
nnoremap <Leader>gf :GFiles<CR>
" Git Status
nnoremap <Leader>gt :GFiles?<CR>
" Local Directory Files
nnoremap <Leader>f :Files<CR>
" File History
nnoremap <Leader>hf :History<CR>
" Search History
nnoremap <Leader>hse :History/<CR>
"Commands History
nnoremap <leader>hc :History:<CR>

" Search the current file with preview
nnoremap <leader>s :BLines<CR>
nnoremap <leader>l :Lines<CR>

noremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>

"" Coding snippets here?
"nnoremap <Leader>ee oif err != nil {<CR>log.Fatalf("%+v\n", err)<CR>}<CR><esc>kkI<esc>

"" Using a terminal inside VIM is bad!! (dont use it)
nnoremap <silent> <leader>sh :terminal<CR>

"" Split
noremap <Leader>] :<C-u>split<CR>
noremap <Leader>\ :<C-u>vsplit<CR>
noremap <Leader>q :<C-u>close<CR>
noremap <Leader>o :<C-u>vnew<CR>


"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>x :bn<CR>

"" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
noremap <leader>c :bp <BAR> bd #<CR>

" delete the current buffer, but not the split
nmap <leader>d :b#<bar>bd#<CR>

" This closes all buffers except current
noremap <leader>ac :w <BAR> %bd <BAR> e# <BAR> bd# <CR>

"" Clean search (highlight)
nnoremap <silent> <leader>, :noh<cr>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Open current line on GitHub
nnoremap <Leader>g :.Gbrowse<CR>

"" Show all current buffers with preview (this is damn good)
nnoremap <silent> <leader>b :Buffers<CR>

" Dont needd this because we have <leader>ps to open Rg:
"nnoremap <silent> <leader>e :FZF -m<CR>


" snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsEditSplit="vertical"

" NERDTree toggle
nmap <silent> <F3> :NERDTreeToggle<CR>

" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

" x X is now the cut command
" dl is used to Delete a single Letter
nnoremap x d
xnoremap x d
nnoremap xx dd
nnoremap X D

" This really deletes (no cut) - Shift-x + d (delete a line)
" nnoremap X "_d
" This Allows to Paste the same thing multiple times
noremap <leader>p "0p


"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>


" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

nnoremap <leader>ob :colorscheme gruvbox<CR>
nmap <leader>tb :hi Normal guibg=NONE ctermbg=NONE<CR>

inoremap <C-c> <esc>

command! -nargs=0 Prettier :CocCommand prettier.formatFile
inoremap <silent><expr> <C-space> coc#refresh()


" GoTo code navigation.
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rr <Plug>(coc-rename)
nmap <leader>g[ <Plug>(coc-diagnostic-prev)
nmap <leader>g] <Plug>(coc-diagnostic-next)
nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev-error)
nmap <silent> <leader>gn <Plug>(coc-diagnostic-next-error)
nnoremap <leader>cr :CocRestart

" ale
let g:ale_linters = {}
:call extend(g:ale_linters, {
    \'python': ['flake8'], })

" vim-airline
let g:airline#extensions#virtualenv#enabled = 1

" Syntax highlight
" Default highlight is better than polyglot
" polyglot breaks markdown fences
let g:polyglot_disabled = ['python', 'markdown', 'mkd']
let python_highlight_all = 1


" Unicode and ponctuation
"" em dashes for markdown
autocmd FileType markdown imap -- –
autocmd FileType markdown imap -+ —
autocmd FileType markdown imap -o º
autocmd FileType markdown imap -a ª

" Sweet Sweet FuGITive
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

autocmd BufWritePre * :call TrimWhitespace()


"*****************************************************************************
"" Convenience variables
"*****************************************************************************

" vim-airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = '▶'
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = '◀'
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
  let g:airline_symbols.linenr    = '␊'
  let g:airline_symbols.branch    = '⎇'
  let g:airline_symbols.paste     = 'ρ'
  let g:airline_symbols.paste     = 'Þ'
  let g:airline_symbols.paste     = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif

"" Disabling arrow keys
" for key in ['<Up>', '<Down>', '<Left>', '<Right>']
"  exec 'nnoremap' key '<Nop>'
"  exec 'vnoremap' key '<Nop>'
" endfor

for key in ['<C-S>', '<C-Z>']
  exec 'noremap' key '<Nop>'
  exec 'inoremap' key '<Nop>'
  exec 'cnoremap' key '<Nop>'
endfor

"" Ctrl+J-K navigates auto complete windows
inoremap <expr> <C-J> pumvisible() ? "\<C-N>" : "j"
inoremap <expr> <C-K> pumvisible() ? "\<C-P>" : "k"


"" Generate uuid
if executable('uuidgen')
    nnoremap <leader>id :execute 'normal! o' . system('uuidgen')<esc>ddk==
else
    nnoremap <leader>id :execute 'normal! o' . system('python3 -c "import uuid; print(str(uuid.uuid4()))"')<esc>ddk==
endif

" -- sudo save
cmap w!! w !sudo tee >/dev/null %

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


function! s:small_terminal() abort
  new
  wincmd J
  call nvim_win_set_height(0, 6)
  set winfixheight
  term
endfunction

" Make a small terminal at the bottom of the screen.
nnoremap <leader>st :call <SID>small_terminal()<CR>

"set statusline+=%F

"DimInactive fade color
highlight ColorColumn ctermbg=0 guibg=#282828
