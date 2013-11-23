
" We're running vim "
set nocompatible
set bs=indent,eol,start

" Report cursor position in document "
set ruler

" Enable highlight current line "
set cursorline

" Enable syntax highlighting "
syntax on

" Enable line numbers "
set number

" Set text fill width "
set textwidth=80
"set formatoptions+=a

" Enable Pathogen "
runtime 'bundle/vim-pathogen/autoload/pathogen.vim'
execute pathogen#infect('bundle/{}')
filetype plugin indent on

" Enable Solarized Theme "
set background=dark
colorscheme solarized

set expandtab
set tabstop=2
set shiftwidth=2

" Enable filetype detection "
filetype on

" Enable filetype-specific indenting "
filetype indent on

" Enable filetype-specific plugins "
filetype plugin on
