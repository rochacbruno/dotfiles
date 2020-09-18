"" Neovim Configuration - @rochacbruno - 2020
" <leader> = ,

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugins managed by Plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

    "" Code Runner, Select a block and :SnipRun
    Plug 'michaelb/sniprun', {'do': 'bash install.sh'}

    "" Python sort imports - C-i on Visual mode or :Isort
    Plug 'fisadev/vim-isort'

    "" Show a popup with leader mappings - :WhichKey or press <Leader> and wait
    Plug 'liuchengxu/vim-which-key'

    "" Show rgb and hexa colors :ColorHighlight
    Plug 'chrisbra/Colorizer'

    "" Multi cursor
    " C-N select words, C-move add cur, Shift move single char,
    " n/N Next/Prev - [] next/prev cur, q skip, Q remove cursor
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}

    "" Markdown editing and preview
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
    Plug 'gabrielelana/vim-markdown' " Linting and highlight
    Plug 'reedes/vim-pencil' " Soft or Hard Word Wrapping - :SoftPencil
    Plug 'junegunn/goyo.vim' " Distraction free - :Goyo
    Plug 'godlygeek/tabular' " Align tables - :Tabularize

    "" Auto Complete and Language Server
    " Leader-prw = Previewable Refactor Work Under Cursor
    " Leader-df = Do Fix on current error
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    "" Git integration
    " Leader-g = Open Line on Git (browser)
    " Leader-gf = List GitFiles
    " Leader-gt  = Show GitStatus
    " Leader-gm  = Show Git Commit Message for Line
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb' " required by fugitive to :Gbrowse
    Plug 'airblade/vim-gitgutter'
    Plug 'rhysd/git-messenger.vim'
    Plug 'stsewd/fzf-checkout.vim' " The  Primeagen told me to install it.
                                   " C-n (new-branch), C-d (del), C-e (Merge),
                                   " C-r (rebase)

    "" Commenting - gcc, gcap
    Plug 'tpope/vim-commentary'

    "" Show latest changes and allow navigation - Leader-u
    Plug 'mbbill/undotree'

    "" Object/AST tag bar - F4
    Plug 'majutsushi/tagbar'

    "" Linter
    Plug 'w0rp/ale'


    "" Show the visual mark on indendation blocks ┆
    Plug 'Yggdroot/indentLine'

    "" Syntax Highlighting
    " Default highlight for Python is better than polyglot
    " Polyglot breaks markdown fences
    let g:polyglot_disabled = ['python', 'markdown', 'mkd']
    let python_highlight_all = 1
    Plug 'sheerun/vim-polyglot'

    "" Rainbow match pairs
    Plug 'frazrepo/vim-rainbow'

    "" Colorize the copied block
    Plug 'machakann/vim-highlightedyank'

    "" Shows search counts
    Plug 'google/vim-searchindex'

    "" Highlight word under cursor
    Plug 'RRethy/vim-illuminate'

    "" Leader-k add highlight, n/N next/prev, Leader-K cleans.
    Plug 'lfv89/vim-interestingwords'

    "" Fade inactive buffers
    Plug 'blueyed/vim-diminactive'

    "" Fuzzy Search :)
    " Leader-ps = Previewable Search
    " Leader-pw = Previewable Search Word under cursor
    " Leader-f = Files on dir
    " Leader-s = Search on buffer
    " Leader-l = Search on all buffers
    " Leader-b = Show all buffers
    " Leader-w = Show all windows
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }

    " Alternative to fzf taht allows preview colorschemes `:Clap colors`
    Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

    " Zoom a window! Ctrl-w-m (maximize)
    Plug 'dhruvasagar/vim-zoom'

    " Dispatch tasks to run async e.g: `:Dispatch PlugInstall`
    Plug 'tpope/vim-dispatch'

    " Allow repeating of plugin 3rd party actions
    Plug 'tpope/vim-repeat'

    " Manipulate surrounding chars such as quotes and brackets
    " Assuming | as a cursor
    " fo|o - ysiw' - 'foo'
    " 'fo|o' - ds' - foo
    " 'fo|o' - cs'" - "foo"
    Plug 'tpope/vim-surround'

    " Beautiful Dark theme
    Plug 'gruvbox-community/gruvbox'
    Plug 'gruvbox-material/vim', {'as': 'gruvbox-material'}

    " Auto Format - :Neoformat black|isort
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

    "" File Manager - F3 - `s` open on split
    Plug 'preservim/nerdtree'

    "" Auto complete navigation with tab
    Plug 'ervandew/supertab'

    "" SQL Stuff
    Plug 'tpope/vim-dadbod'
    Plug 'kristijanhusak/vim-dadbod-ui'

    "" Move windows in a good way using C-wg-hjkl
    Plug 'andymass/vim-tradewinds'

    "" Command to show leader commands - :Bufferize Leaders
    Plug 'derekprior/vim-leaders'

    "" Interact with output of commands e.g :Bufferize cargo watch
    Plug 'AndrewRadev/bufferize.vim'

    "" text moving (Select a text and Alt-hjkl)
    Plug 'matze/vim-move'

    "" File/Buffer operations :Rename, :Move, :Delete, :Chmod, :SudoEdit
    Plug 'tpope/vim-eunuch'

    "" Delete instead of cut (cut is mapped to x, single char is  dl)
    Plug 'svermeulen/vim-cutlass'

    "" HTML magic - Ctrl-y
    Plug 'mattn/emmet-vim'

    "" Create gist with :Gist -c
    Plug 'mattn/gist-vim'
    Plug 'mattn/webapi-vim'

    "" Make me dirs when saving a full path
    Plug 'pbrisbin/vim-mkdir'

    "" Auto Completion from ZSH auto completions
    Plug 'tjdevries/coc-zsh'

    "" Better repeatable f/t searching
    Plug 'rhysd/clever-f.vim'

    "" `dsf`  deletes surrounding function `csf` change it
    Plug 'AndrewRadev/dsf.vim'

    "" `cx` exchange 2 words `cxx` exchange 2 line
    Plug 'tommcdo/vim-exchange'

    "" After a visual selection use + and - to expand it
    Plug 'landock/vim-expand-region'

    "" Sets working dir automatically
    Plug 'airblade/vim-rooter'

    "" Scratch `gs`
    Plug 'mtth/scratch.vim'

    "" i3 filetype
    Plug 'mboughaba/i3config.vim'

    "" Split window based on visual selection
    " C-W-gsa creates a split above with the selection C-W-gss on right
    " CW-gr resizes to selection
    Plug 'wellle/visual-split.vim'

    "" A color picker - <leader>C
    Plug 'KabbAmine/vCoolor.vim'

    "" Registers history sidebar
    Plug 'junegunn/vim-peekaboo'

    ""
"" End of plugin management
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Common VIM settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on                       " Enable defautl highlight
filetype plugin indent on       " Enable filetype detection
                                " for plugin and indentation

set number relativenumber       " Show line numbers, relative mode
set hidden                      " Allow multiple hidden buffers
set cursorline                  " Highlight current line
set cursorcolumn                " Highlight current column
set noerrorbells                " Don't play sound on error
set tabstop=4 softtabstop=4     " Tabs to spaces
set shiftwidth=4                " Indent width when using <>
set expandtab                   " Automatically turn tab to space
                                " USe Ctrl+V tab to insert a real tab
set smartindent                 " Detect file indentation
set smartcase                   " Smart case on search
set ignorecase                  " Ignore case on search
set noswapfile                  " Don't write swap files
set nobackup                    " Don't make backups
set undodir=~/.vim/undodir      " Where to save undo history
set undofile                    " Enable the undo saving
set incsearch                   " Start searching before enter is pressed
set termguicolors               " Enable 24 bit colors
set scrolloff=8                 " Scroll line offser kept above cursor
set noshowmode                  " Don't print mode in status line
set encoding=utf-8              " default encoding for buffers
set fileencoding=utf-8          " default encoding for files
set fileencodings=utf-8         " same as above but it is a list
set backspace=indent,eol,start  " Backspace/Ctrl-H settings
set hlsearch                    " Highlight all search matches
set fileformats=unix,dos,mac    " file formats
set nowritebackup               " No backup before write
set splitbelow                  " :split creates below window
set splitright                  " :vspclit creates right window
set noequalalways               " Don't change window sizes when opening new
set updatetime=50               " Makes things faster
set shortmess+=c                " Don't pass messages to |ins-completion-menu|.
set mousemodel=popup            " Mouse right click opens term menu (if exists)
set mouse=a                     " Mouse enabled in all modes/features
set t_Co=256                    " Something about tmux and colors :/

if exists('$SHELL')             " Sets the shell to open inside vim
    set shell=$SHELL
else
    set shell=/bin/sh
endif

set laststatus=2                " Always show Status bar

set modeline                    " Reads a special line `# vim:` on
set modelines=10                " top of files to change local configs

set title                       " Pass file title to terminal title
set titleold="Terminal"         " Default title to be set
set titlestring=%F              " format for the title using pritf
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
                                " Default Statusline formatting
                                " overriden by vim-airline

set list                        " Show tabs and spavces visually

set showbreak=↳
set listchars+=tab:→→\|,space:.,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

set nojoinspaces                " No space when joining lines

set confirm                     " Dialog to confirm operations

"set foldmethod=indent           " Folds are done by indentation
"set foldlevelstart=1            " When opening a file only folds 1 level

set virtualedit=block           " Allow placing cursor where there is no char
                                " adding: ,onemore will allow cursor on the  end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Custom settings and Plugin Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","             " Leader is ,

let g:scratch_persistence_file = '~/vim_scratch/' . strftime("%Y-%m-%d")  . '.md'
                                " where to save `gs` scratch?

aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.i3/config set filetype=i3config
aug end
                                " Dynamically i3 filetype setting

let g:rainbow_active = 1        " rainbow brackets enabled

let g:mkdp_auto_start = 0       " Don't open md preview automatically
let g:mkdp_auto_close = 0       " Don't close md preview automatically

let g:session_directory = "~/.config/nvim/session" " Session saving
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

let g:indentLine_enabled = 1    " Enables indentline plugin
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_faster = 1

" FZF and Rg settings for search
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
if executable('rg')
  let g:rg_derive_root='true'
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

"" Uncomment below to show :Rg in a popup
" let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

" snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsEditSplit="vertical"

" Gist Plugin Options
let g:gist_clip_command = 'xclip -selection clipboard'  " Copy :Gist -c URL
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1

"let loaded_matchparen = 1                  " Disables Match parent

if has('unnamedplus') " Copy/Paste/Cut
  set clipboard=unnamed,unnamedplus
endif

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

let g:ale_linters = {}            " Extend the linters
:call extend(g:ale_linters, {
    \'python': ['flake8'], })

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Appearance
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:gruvbox_contrast_dark = 'hard'       " Set gruvbox bg to real dark
let g:gruvbox_material_background = 'hard' " Same but for -material alt
let g:gruvbox_invert_selection='0'         " Don't invert selection
set background=dark                        " Set global background to dark
colorscheme gruvbox-material               " Default colorscheme

" Set original bg
nnoremap <leader>ob :colorscheme gruvbox-material<CR>

" Set transparent bg
nmap <leader>tb :hi Normal guibg=NONE ctermbg=NONE<CR>

let g:airline_theme = 'gruvbox_material'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline_skip_empty_sections = 1

set colorcolumn=80,100,120                     " Limit rulers

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Bindings  Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" I use NERDTree so I kept it here just as an example.
" nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

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

" Create Splits based on visual selection
xmap <C-W>gr  <Plug>(Visual-Split-VSResize)
xmap <C-W>gss <Plug>(Visual-Split-VSSplit)
xmap <C-W>gsa <Plug>(Visual-Split-VSSplitAbove)
xmap <C-W>gsb <Plug>(Visual-Split-VSSplitBelow)

" Opens undotree history
nnoremap <leader>u :UndotreeShow<CR>


" Git Stuff
nnoremap <leader>gc :GBranches<CR>
nnoremap <leader>ga :Git fetch --all<CR>
nnoremap <leader>grum :Git rebase upstream/master<CR>
nnoremap <leader>grom :Git rebase origin/master<CR>

" Get Help for Word
nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>

" Preview Refactor on Word
nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>

" Preview Search
nnoremap <Leader>ps :Rg<CR>
nnoremap <Leader>r :Rg<CR>

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

" Reload configs
noremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>

" Resize Window Vertically
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>

"" Creates Splits
" Horizontal
noremap <Leader>] :<C-u>split<CR>

" Vertical
noremap <Leader>\ :<C-u>vsplit<CR>

" Empty vertical
noremap <Leader>o :<C-u>vnew<CR>

"" Controls Splits
" Close Split
noremap <Leader>q :<C-u>close<CR>

" Previous BUffer
noremap <leader>z :bp<CR>

" Next Buffer
noremap <leader>x :bn<CR>

" Close buffer and jump to previous
noremap <leader>c :bp <BAR> bd #<CR>

" delete buffer, but not the split
nmap <leader>d :b#<bar>bd#<CR>

" Close others
noremap <leader>ac :w <BAR> %bd <BAR> e# <BAR> bd# <CR>

" Clean Search highlight
nnoremap <silent> <leader><space> :noh<cr>

" Vmap for maintain Visual Mode
vmap < <gv

" after shifting > and <
vmap > >gv

" Open current line on GitHub
nnoremap <Leader>g :.Gbrowse<CR>

" Preview buffers
nnoremap <silent> <leader>b :Buffers<CR>

" Preview windows
nnoremap <silent> <leader>w :Windows<CR>

" Open a color picker
nnoremap <leader>C :VCoolor<CR>

" NERDTree File Manager
nmap <silent> <F3> :NERDTreeToggle<CR>

" Show Tagbar
nmap <silent> <F4> :TagbarToggle<CR>

let g:tagbar_autofocus = 1               " Auto focus on tagbar

"" Vim cutlass turns `d` into real delete
"" dl is used to delete a single Letter
" Cut a move
nnoremap x d
xnoremap x d

" Cut a line
nnoremap xx dd

" Cut until end of line
nnoremap X D

" Paste the same thing multiple times
noremap <leader>p "0p

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Open file cur path
noremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Don't use tabs - buffers and windows are easier.
" Open file in a tab
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Next tab
nnoremap <Tab> gt

" Previous Tab
nnoremap <S-Tab> gT

" New tab
nnoremap <silent> <S-t> :tabnew<CR>

" center on window
nnoremap n nzzzv

" after a search result
nnoremap N Nzzzv

" Easy esc on control-c
inoremap <C-c> <esc>

"" Coc
" Format file
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Refresh Coc
inoremap <silent><expr> <C-space> coc#refresh()

" nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gd :sp<CR><Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rr <Plug>(coc-rename)
nmap <leader>g[ <Plug>(coc-diagnostic-prev)
nmap <leader>g] <Plug>(coc-diagnostic-next)
nmap <silent> <leader>df <Plug>(coc-fix-current)
nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev-error)
nmap <silent> <leader>gn <Plug>(coc-diagnostic-next-error)
nnoremap <leader>cr :CocRestart

" Unicode and ponctuation / em dashes for markdown
autocmd FileType markdown imap -- –
autocmd FileType markdown imap -+ —
autocmd FileType markdown imap -o º
autocmd FileType markdown imap -a ª

" FuGITive
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>

" Makes j k to move to screen line when there is a wrap
nnoremap j gj
nnoremap k gk

" Makes f1 an extra esc key instead of help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Easy to save a file using only ;w
nnoremap ; :

"Easy window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Functions and customizations
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" Disable Control S/Z
for key in ['<C-S>', '<C-Z>']
  exec 'noremap' key '<Nop>'
  exec 'inoremap' key '<Nop>'
  exec 'cnoremap' key '<Nop>'
endfor

" Down on autocomplete
inoremap <expr> <C-J> pumvisible() ? "\<C-N>" : "j"

" Up on autocomplete
inoremap <expr> <C-K> pumvisible() ? "\<C-P>" : "k"

" Generate UUID
nnoremap <leader>id :read !uuidgen<esc>k :join<esc>

" Current DateTime
nmap <F6> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>

" Save with sudo
cmap w!! w !sudo tee >/dev/null %

" Add a :Format command
command! -nargs=0 Format :call CocAction('format')

" Add fold command
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

function! s:small_terminal() abort
  new
  wincmd J
  call nvim_win_set_height(0, 6)
  set winfixheight
  term
endfunction
" Make a small terminal.
nnoremap <leader>st :call <SID>small_terminal()<CR>


" Reload  externally changed files
set autoread

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
    \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
    \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Isort
let g:vim_isort_config_overrides = {
  \ 'include_trailing_comma': 1, 'multi_line_output': 3}
let g:vim_isort_python_version = 'python3'
let g:vim_isort_map = '<C-i>'

" Shows a CheatSheet
nnoremap <silent> <leader> :WhichKey ','<CR>
