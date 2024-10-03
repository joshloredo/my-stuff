" Basic Settings
set nocompatible            " Disable Vi compatibility for better Vim features
set number                  " Show line numbers
set relativenumber          " Relative line numbers for quick movement
set cursorline              " Highlight the current line
syntax on                   " Enable syntax highlighting
filetype plugin indent on   " Enable filetype detection and indentation

" Searching
set incsearch               " Highlight as you type your search
set hlsearch                " Highlight all matches
set ignorecase              " Ignore case in search patterns
set smartcase               " Case-sensitive search if uppercase is used
nnoremap <Leader><space> :nohlsearch<CR> " Clear search highlighting with <Leader><space>

" Tabs and Indentation
set tabstop=4               " Tab width of 4 spaces
set shiftwidth=4            " Indent by 4 spaces
set expandtab               " Use spaces instead of tabs
set autoindent              " Auto-indent new lines

" File Explorer
nnoremap <Leader>e :Explore<CR> " Open file explorer with <Leader>e

" Splitting and Navigation
set splitright              " Open vertical splits to the right
set splitbelow              " Open horizontal splits below
nnoremap <Leader>v :vsplit<CR>   " Quickly split vertically with <Leader>v
nnoremap <Leader>h :split<CR>    " Quickly split horizontally with <Leader>h

" Navigate between windows
nnoremap <C-h> <C-w>h       " Move to the left split
nnoremap <C-l> <C-w>l       " Move to the right split
nnoremap <C-j> <C-w>j       " Move to the below split
nnoremap <C-k> <C-w>k       " Move to the above split

" Better Scrolling
nnoremap <C-d> <C-d>zz      " Scroll down and center
nnoremap <C-u> <C-u>zz      " Scroll up and center
nnoremap n nzzzv            " Center search results after 'n'
nnoremap N Nzzzv            " Center search results after 'N'

" Faster File Navigation
set wildmenu                " Command-line completion enhanced
set wildmode=longest:full,full

" Set up a fancy statusline
set laststatus=2            " Always show status line
set statusline=%f\ [%y]\ %m%r%h%w\ [%p%%]\ [%l/%L] " Show filename, filetype, modified, etc.

" Persistent Undo
set undodir=~/.vim/undodir  " Directory for undo history
set undofile                " Enable persistent undo

" View Log Files More Easily
set nowrap                  " Don't wrap lines by default (important for logs)
nnoremap <Leader>w :set wrap!<CR> " Toggle wrap with <Leader>w for long lines in logs

" Easier Navigation Between Buffers
nnoremap <Tab> :bnext<CR>   " Move to the next buffer with Tab
nnoremap <S-Tab> :bprevious<CR> " Move to the previous buffer with Shift-Tab

" Fuzzy Finder (if fzf is installed)
if executable('fzf')
  nnoremap <Leader>f :Files<CR>  " Fuzzy find files with fzf
endif

" Better Yank/Paste
set clipboard=unnamedplus   " Use system clipboard
vnoremap <Leader>y "+y      " Yank to system clipboard
vnoremap <Leader>p "+p      " Paste from system clipboard

" Code Folding
set foldmethod=syntax       " Fold based on syntax
set foldlevelstart=99       " Start with all folds open
nnoremap <Leader>z za       " Toggle fold with <Leader>z

" Visual Mode Indentation
vnoremap < <gv              " Keep selection when indenting left
vnoremap > >gv              " Keep selection when indenting right

" Disable Swap Files (useful for environments where swap files aren't desired)
set noswapfile

" Display hidden characters (good for viewing log files)
set listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:␣
set list

" Quick Save
nnoremap <Leader>s :w<CR>   " Save the file with <Leader>s

" Colorscheme (Pick your favorite or install a custom one)
colorscheme desert          " Choose a comfortable colorscheme