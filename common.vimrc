" General Settings {{{

" Use vim, not vi API
set nocompatible

" Disable use of swap and backup files
set nobackup nowritebackup noswapfile

" Show command history
set history=150

" Show incomplete commands
set showcmd

" Prevent quitting vim with hidden buffers (unfocused with unsaved changes)
set hidden

" Disable splash screen
set shortmess+=I

" }}}

" ---- Editor {{{
" UTF encoding
set encoding=utf-8

" Enable syntax highlighting
syntax on

" Disable wordwrap
set nowrap

" Show cursor
set ruler

" Show line numbers
set number

" Use system clipboard
set clipboard+=unnamed

" Highlight current line
set cursorline

" highlight a matching [{()}] when cursor is placed on start/end character
set showmatch

" Always highlight column 80 so it's easier to see where
 autocmd BufWinEnter * highlight ColorColumn ctermbg=darkred
 set colorcolumn=80

" Get rid of command delays
set timeout timeoutlen=1000 ttimeoutlen=100

" Ensure Vim doesn't beep at you every time you make a mistype
set visualbell

" Visual autocomplete for command menu (e.g. :e ~/path/to/file)
set wildmenu

" }}}

" ---- Search {{{
" Search while typing
set incsearch

" Search highlit matches
set hlsearch

" Search ignore case
set smartcase
set ignorecase
" }}}

" ---- Tabs and Spacing {{{
" Convert tabs to spaces
set expandtab

" Set tab size for manual indenting
set tabstop=3

" Set tab size for auto indenting
set shiftwidth=3

" Permit backspace to delete whitespace characters
set backspace=indent,eol,start

" Highlight trailing whitespace
set list listchars=tab:\ \ ,trail:·
" }}}

" ---- Status Bar {{{
" Show status bar
set laststatus=2

" Set the status bar text
" set statusline=%f\ %=L:%l/%L\ %c\ (%p%%)

" Hide the toolbar
set guioptions-=T

" }}}

" ---- Buffers and Windows {{{

" Autoload files that have changed outside of vim
set autoread

" Better splits (new windows appear below and to the right)
set splitbelow
set splitright

" redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw

" }}}

" Plugin Manager {{{
" ==============

" To install, execute :PluginInstall
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vim
Plugin 'git@github.com:gmarik/Vundle.vim'

" File System Navigation
Plugin 'git@github.com:scrooloose/nerdtree'

" Text/Code Navigation
Plugin 'git@github.com:majutsushi/tagbar'
Plugin 'git@github.com:kien/ctrlp.vim'

" Look and Feel
Plugin 'git@github.com:bling/vim-airline'
Plugin 'git@github.com:flazz/vim-colorschemes'

" Special File Types
Plugin 'git@github.com:godlygeek/tabular'
Plugin 'git@github.com:plasticboy/vim-markdown'
Plugin 'aklt/plantuml-syntax'

" Version Control
Plugin 'git@github.com:airblade/vim-gitgutter'
Bundle 'git@github.com:mattn/webapi-vim'
Bundle 'git@github.com:mattn/gist-vim'

call vundle#end()
filetype plugin indent on
" }}}

" ---- colorschemes plugin {{{
set t_Co=256
set background=dark
" colorscheme wombat256
colorscheme jellybeans
" }}}

" ---- airline plugin {{{
let g:airline_powerline_fonts=1
" let g:airline_theme='wombat'
let g:airline_theme='jellybeans'
" }}}

" ---- ctrl-p plugin {{{
map <leader><leader> <C-p>
map <leader>b :CtrlPBuffer<cr>
map <leader>t :CtrlPTag<cr>
let g:ctrlp_show_hidden=1
let g:ctrlp_working_path_mode=0
let g:ctrlp_max_height=30

" " CtrlP -> override <C-o> to provide options for how to open files
let g:ctrlp_arg_map = 1

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*.,*/.DS_Store

let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ackprg = 'ag --nogroup --nocolor --column'

" " CtrlP -> directories to ignore when fuzzy finding
let g:ctrlp_custom_ignore = '\v[\/]((node_modules)|\.(git|svn|grunt|sass-cache))$'
" }}}

" ---- gist plugin {{{
let g:github_user = $GITHUB_USER
let g:github_token = $GITHUB_TOKEN
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 0

" Make gists private by default
let g:gist_post_private = 1

" Show private gists when executing :Gist -l
let g:gist_show_privates = 1
" }}}

" ---- gitgutter plugin {{{
let g:gitgutter_enabled = 1
let g:gitgutter_eager = 0
let g:gitgutter_sign_column_always = 1
highlight clear SignColumn
" }}}

" ---- nerdtree plugin {{{
map <leader>[ :NERDTreeToggle<cr>
" }}}

" ---- tabularize plugin {{{
map <Leader>e :Tabularize /=<cr>
map <Leader>c :Tabularize /:<cr>
map <Leader>es :Tabularize /=\zs<cr>
map <Leader>cs :Tabularize /:\zs<cr>
" }}}

" ---- tagbar plugin {{{
map <leader>] :TagbarToggle<cr>
" }}}

" Mappings {{{
" Notes...
"
" :map     j gg (j will be mapped to gg)
" :map     Q j  (Q will also be mapped to gg, because j will be expanded -> recursive mapping)
" :noremap W j  (W will be mapped to j not to gg, because j will not be expanded -> non recursive)
"
" These mappings work in all modes. To have mappings work in only specific
" modes then denote the mapping with the mode character.
"
" e.g.
" to map something in just NORMAL mode use :nmap or :nnoremap
" to map something in just VISUAL mode use :vmap or :vnoremap

" Clear search buffer
:nnoremap § :nohlsearch<cr>

" Command to use sudo when needed
cmap w!! %!sudo tee > /dev/null %

" File System Explorer (in horizontal split)
map <leader>. :Sexplore<cr>

" Buffers
map <leader>yt :ls<cr>

" Buffers (runs the delete buffer command on all open buffers)
map <leader>yd :bufdo bd<cr>

" Make handling vertical/linear Vim windows easier
map <leader>w- <C-W>- " decrement height
map <leader>w+ <C-W>+ " increment height
map <leader>w] <C-W>_ " maximize height
map <leader>w[ <C-W>= " equalize all windows

" Handling horizontal Vim windows doesn't appear to be possible.
" Attempting to map <C-W> < and > didn't work
" Same with mapping <C-W>|

" Make splitting Vim windows easier
map <leader>; <C-W>s
map <leader>` <C-W>v

" Running Tests...
" See also <https://gist.github.com/8114940>

" Run currently open RSpec test file
map <Leader>rf :w<cr>:!rspec % --format nested<cr>

" Run current RSpec test
" RSpec is clever enough to work out the test to run if the cursor is on any line within the test
map <Leader>rl :w<cr>:exe "!rspec %" . ":" . line(".")<cr>

" Run all RSpec tests
map <Leader>rt :w<cr>:!rspec --format nested<cr>

" Run currently open cucumber feature file
map <Leader>cf :w<cr>:!cucumber %<cr>

" Run current cucumber scenario
map <Leader>cl :w<cr>:exe "!cucumber %" . ":" . line(".")<cr>

" Run all cucumber feature files
map <Leader>ct :w<cr>:!cucumber<cr>

" Tmux style window selection
map <Leader>ws :ChooseWin<cr>
" }}}

" Commands {{{
" jump to last cursor
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

fun! StripTrailingWhitespace()
  " don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif
  %s/\s\+$//e
endfun
autocmd BufWritePre * call StripTrailingWhitespace()

" file formats
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType sh,cucumber,ruby,yaml,zsh,vim setlocal shiftwidth=2 tabstop=2 expandtab

" specify syntax highlighting for specific files
autocmd Bufread,BufNewFile *.spv set filetype=php
autocmd Bufread,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?

" Highlight words to avoid in tech writing
" http://css-tricks.com/words-avoid-educational-writing/
highlight TechWordsToAvoid ctermbg=red ctermfg=white
match TechWordsToAvoid /\cobviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however\|so,\|easy/
autocmd BufWinEnter * match TechWordsToAvoid /\cobviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however,\|so,\|easy/
autocmd InsertEnter * match TechWordsToAvoid /\cobviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however,\|so,\|easy/
autocmd InsertLeave * match TechWordsToAvoid /\cobviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however,\|so,\|easy/
autocmd BufWinLeave * call clearmatches()

" Create a 'scratch buffer' which is a temporary buffer Vim wont ask to save
" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
    if part[0] =~ '\v[%#<]'
      let expanded_part = fnameescape(expand(part))
      let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
    endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" Close all folds when opening a new buffer
autocmd BufRead * setlocal foldmethod=marker
autocmd BufRead * normal zM

" Rainbow parenthesis always on!
if exists(':RainbowParenthesesToggle')
  autocmd VimEnter * RainbowParenthesesToggle
  autocmd Syntax * RainbowParenthesesLoadRound
  autocmd Syntax * RainbowParenthesesLoadSquare
  autocmd Syntax * RainbowParenthesesLoadBraces
endif

" Reset spelling colours when reading a new buffer
" This works around an issue where the colorscheme is changed by .local.vimrc
fun! SetSpellingColors()
  highlight SpellBad cterm=bold ctermfg=white ctermbg=red
  highlight SpellCap cterm=bold ctermfg=red ctermbg=white
endfun
autocmd BufWinEnter * call SetSpellingColors()
autocmd BufNewFile * call SetSpellingColors()
autocmd BufRead * call SetSpellingColors()
autocmd InsertEnter * call SetSpellingColors()
autocmd InsertLeave * call SetSpellingColors()

" Change colourscheme when diffing
fun! SetDiffColors()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkGrey
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun
autocmd FilterWritePre * call SetDiffColors()
" }}}
