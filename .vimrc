set nocompatible               
set laststatus=2
filetype off                   

set rtp+=~/.vim/bundle/vundle/

call vundle#rc()

Bundle 'gmarik/vundle'

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

let g:airline_left_sep=' ≠'
let g:airline_right_sep='≠ '

set number
set backspace=2
set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set expandtab
set conceallevel=2
syntax on

nnoremap th :tabnext<CR>
nnoremap tl :tabprev<CR>
nnoremap tn :tabnew<CR>

set background=dark
colorscheme base16-default
filetype plugin indent on



