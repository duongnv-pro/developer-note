set number " Shows line number on the left and relative line numbering
set relativenumber
set nowrap
set showmatch		" Show matching brackets.
set expandtab
set tabstop=2
set shiftwidth=2
set smarttab
set ttimeoutlen=0 " Remove delay when switching modes: insert to normal
set list | set listchars=eol:¬,tab:▸\

call plug#begin('~/.config/nvim/bundle')

Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/loremipsum'
Plug 'preservim/nerdtree'
"Plug 'mortonfox/nerdtree-clip'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
"Plug 'tpope/vim-vinegar'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'APZelos/blamer.nvim'

call plug#end()

set encoding=UTF-8

" configure gruvbox
colorscheme gruvbox
set background=dark

" Mappings for choosing patch in merge view
nmap <leader>gh :diffget //2<CR> " use $LOCAL
nmap <leader>gl :diffget //3<CR> " use $REMOTE
" FZF shortcut
nmap <c-p> :FZF<cr>
" ALEFix shortcut
nmap <leader>f :ALEFix<cr>
" htmlbeautifier shortcut
nmap <leader>h :!htmlbeautifier %<cr><cr>

" ALE setup
let g:ale_linters = {
\   'ruby': ['rubocop', 'ruby', 'standardrb'],
\   'eruby': ['erblint'],
\}
" Fixer for erb: htmlbeautifier
" :!htmlbeautifier %
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'ruby': ['trim_whitespace', 'remove_trailing_lines','rubocop'],
\   'eruby': ['erblint'],
\   'css': ['prettier'],
\}
" Only run tools that are specified instead of run all tools available
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 0

" Remap NERDTree
nmap - :NERDTreeToggle<cr>
" Shortcut to search for visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Map spliting screen
nmap <leader>" :split<cr>
nmap <leader>% :vsplit<cr>
