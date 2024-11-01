" disable compatibility with vi
set nocompatible

set shell=zsh\ -i

" set encoding
set encoding=utf-8

" enable line number
set number

" load an indent file for the detected file type
filetype indent on

" enable syntaxt highlighting
syntax on

" set shift width
set shiftwidth=2

" set tab width
set tabstop=2

" use space for indent
set expandtab

" disable line warp
set nowrap

" highlight matching characters
set incsearch
set showmatch
set hlsearch

" disable highlight after press ESC
nnoremap <CR> :nohlsearch<CR><CR>

" enable auto completion menu (press TAB)
set wildmenu

" make wildmenu behave like similar to Bash completion
set wildmode=list:longest

" disable sound effect
set noerrorbells
set visualbell

" copy indent from current line when starting a new line
set autoindent

" even better autoindent (e.g. add indent after '{')
set smartindent

" autoreload the file in Vim if it has been changed outside of Vim
set autoread

" Enable scroll and selection with mouse
set mouse=a

" status line
set laststatus=2
set statusline=\ %F
set statusline+=%=
set statusline+=\ %M\ %Y\

" disable backup (It's very simple, always save!)
set nobackup
set nowritebackup
set noswapfile

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set t_Co=256

" Set paste mode key.
set pastetoggle=<C-p>

" line warp for markdown
augroup Markdown
  autocmd!
  autocmd FileType markdown set wrap
augroup END

" Save and exist keymap
inoremap <C-s> <esc>:w<cr> " save files
nnoremap <C-s> :w<cr>
inoremap <C-d> <esc>:wq!<cr> " save and exit
nnoremap <C-d> :wq!<cr>
inoremap <C-q> <esc>:qa!<cr> " quit discarding changes
nnoremap <C-q> :qa!<cr>


" Return to last edit position when opening files. 
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Hide typescript build file
let NERDTreeIgnore=['\.js$[[file]]', '\.js.map$[[file]]', '\.d.ts$[[file]]']

" enable plugins and load plugin for the detected file type
filetype plugin on

call plug#begin()

Plug 'itchyny/lightline.vim'
Plug 'sainnhe/everforest', { 'as' : 'everforest'}
" Plug 'preservim/nerdtree'
Plug 'LunarWatcher/auto-pairs'

Plug 'xolox/vim-misc'
Plug 'majutsushi/tagbar'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'leafgarland/typescript-vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

call plug#end()

set rtp+=/opt/homebrew/opt/fzf

" lightline.vim
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename' ] ],
      \   'right': [ [ 'percent' ],
      \              [ 'filetype' ] ]
      \ },
      \ 'component_function': {
        \   'filename': 'LightlineFilename',
      \ },
      \ }

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

" NerdTree

" autocmd VimEnter * NERDTree

" In NERDTree, to open-silently file in newtab with Enter, instead of default pressing "T" (same for not silently with Tab instead of t)
" let NERDTreeMapOpenInTab='<TAB>'
" let NERDTreeMapOpenInTabSilent='<ENTER>'
" Close on all file closed
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
"       \ && b:NERDTree.isTabTree()) | q | endif

" Required after having changed the colorscheme
hi clear SignColumn
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" Theme

set background=dark

colorscheme everforest
let g:lightline = {'colorscheme' : 'everforest'}
let g:everforest_background = 'hard'

set backspace=indent,eol,start
