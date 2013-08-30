"setup
set number
set backspace=2
set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set expandtab
set conceallevel=2
set nocompatible               
set laststatus=2
set encoding=utf-8
set nobackup
set noswapfile

set hlsearch "highlight search
set ignorecase "search case insensitive

filetype off                   
syntax on

"vundle
set rtp+=~/.vim/bundle/vundle/

call vundle#rc()

Bundle 'gmarik/vundle'

"plugins

Bundle 'airblade/vim-gitgutter'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/syntastic'
Bundle 'Valloric/YouCompleteMe'
Bundle 'myhere/vim-nodejs-complete'
Bundle 'fsouza/go.vim'
Bundle 'mmalecki/vim-node.js'
Bundle 'altercation/vim-colors-solarized'
Bundle 'elixir-lang/vim-elixir'
Bundle 'nuclearsandwich/fancy-vim'
Bundle 'chriskempson/base16-vim'
Bundle 'kien/ctrlp.vim'
Bundle 'vim-scripts/VimClojure'
Bundle 'tpope/vim-commentary'
Bundle 'scrooloose/nerdtree'

"nerdtree hacks
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"keymaps

map <F4> :NERDTreeToggle<CR>
nnoremap <F2> :tabnext<CR>
nnoremap <F1> :tabprev<CR>
nnoremap <F3> :tabnew<CR>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap , :
nnoremap j gj
nnoremap k gk

cmap w!! w !sudo tee % >/dev/null "autosudo in case of need"

"colorscheme

set background=dark
colorscheme base16-default
filetype plugin indent on



