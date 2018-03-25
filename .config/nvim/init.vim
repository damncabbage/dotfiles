
" ------- Plugins (vim-plug) -------
call plug#begin('~/.local/share/nvim/plugged')

	Plug 'kassio/neoterm'
	Plug 'neomake/neomake'
	"Plug 'w0rp/ale'

	Plug 'scrooloose/nerdtree'
  Plug 'simnalamburt/vim-mundo' " Gundo fork.

	Plug 'ervandew/supertab' " Tab-completion; stand-in until I get YouCompleteMe.

	" Highlighting
	Plug 'lambdatoast/elm.vim'
	Plug 'mustache/vim-mustache-handlebars' " Handlebars / BMX
	Plug 'raichoo/purescript-vim'

	Plug 'bitc/vim-hdevtools' " Haskell type inspection

	"Plug 'flowtype/vim-flow', { 'for': 'javascript' }

	" Colorschemes
	Plug 'rakr/vim-two-firewatch'
	Plug 'jnurmine/Zenburn'
	Plug 'chriskempson/base16-vim'
	Plug 'dracula/vim'
	Plug 'altercation/vim-colors-solarized'
	Plug 'albertorestifo/github.vim'
	"Plug 'vim-scripts/kate.vim'
	Plug 'muellan/am-colors'
	"Plug 'kazmasaurus/Baby-The-Code-Shines-Bright'
	Plug 'xonecas/BabyTheCodeShinesBright'

call plug#end()


" ------- Global Config -------

set foldmethod=indent
set foldnestmax=5
set foldlevelstart=99
set foldcolumn=0

set history=700 " lines of history

set autoread " Reload when a file is changed from outside vim

set ruler " Show current position
"set number " DEMO RIG

set tm=2000 " Leader key timeout

set tags=tags

" No annoying sound on errors
set noerrorbells
set vb t_vb=

set autoindent
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab

" DEMO RIG - Sign column always present.
""let g:ale_sign_column_always = 1
autocmd BufRead * sign define dummy
autocmd BufRead * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" Show trailing whitespace
""highlight default BadWhitespace ctermbg=red guibg=red
""autocmd ColorScheme <buffer> highlight default BadWhitespace ctermbg=red guibg=red
""match BadWhitespace /\s\+$/

" Return to last edit position when opening files:
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
" TODO: Is this needed for the above? [set viminfo^=% " Remember info about open buffers on close]

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
  autocmd bufwritepost init.vim source $MYVIMRC
augroup END


" ------- Filetype Config ------

filetype plugin on


" ------- Plugin Config -------

" --- colorscheme ---
set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" vim-two-firewatch
"""set background=dark " or light if you prefer the light version
""""let g:two_firewatch_italics=1
"""colo two-firewatch
"""let g:airline_theme='twofirewatch' " For Airline, when we install it.
"colo base16-chalk
"colo base16-eighties
"colo base16-flat
"colo base16-materia
set background=light
colo github
"colo amcolors
"colo kate
"colo Baby_the_code_shines_bright

" DEMO RIG - Line numbers, with background matching the body text.
highlight LineNr guibg=bg
highlight SignColumn guibg=bg

" --- Supertab ---
" Use buffer words as default tab completion
let g:SuperTabDefaultCompletionType = '<c-x><c-p>'

""" --- Ale ---
""let g:ale_set_higlights = has('syntax')  " fixes typo in ALE
""let g:ale_echo_msg_format = '%linter%: %s'
""let g:ale_lint_on_save = 1
""let g:ale_lint_on_text_changed = 0
""
""let g:ale_set_loclist = 0
""let g:ale_set_quickfix = 1
""let g:ale_open_list = 1
""let g:ale_keep_list_window_open = 1
""
""let g:ale_linters = {
""\   'javascript': ['flow'],
""\}


" --- neomake ---
hi ErrorMsg guifg=#bd2c00 ctermfg=124 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
let g:neomake_error_sign = { 'text': '✖', 'texthl': 'ErrorMsg' }
let g:neomake_warning_sign = { 'text': '🔜', 'texthl': 'WarningMsg' }
"let g:neomake_open_list = 2
let g:neomake_place_signs = 1

" --- neomake + flow-vim-quickfix ---
function! StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction
let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))

let g:neomake_javascript_enabled_makers = []
let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))
if findfile('.flowconfig', '.;') !=# ''
  let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))
  if g:flow_path != 'flow not found'
    let g:neomake_javascript_flow_maker = {
          \ 'exe': 'sh',
          \ 'args': ['-c', g:flow_path.' --json 2> /dev/null | flow-vim-quickfix-hack'],
          \ 'errorformat': '%E%f:%l:%c\,%n: %m',
          \ 'cwd': '%:p:h'
          \ }

    let g:neomake_javascript_enabled_makers = g:neomake_javascript_enabled_makers + [ 'flow']
  endif
endif

" This is kinda useful to prevent Neomake from unnecessary runs
if !empty(g:neomake_javascript_enabled_makers)
	autocmd BufWritePost,BufRead * if &ft ==# 'javascript' | Neomake | endif
endif

" Get the Flow type at the current cursor position.
function! StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction
let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))
function! FlowGetType()
  let pos = fnameescape(expand('%')).' '.line('.').' '.col('.')
	let wordUnderCursor = expand("<cword>")
  let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))
  if g:flow_path != 'flow not found'
		let cmd = g:flow_path.' type-at-pos '.pos
		let output = '↳  '.system(cmd)
		let output = substitute(output, '\n.*', '', '') " Avoid 'press ENTER' prompt by limiting to one line.
		echo output
	endif
endfunction
command! FlowType call FlowGetType()

command! -nargs=1 R execute ":split | term " <q-args>


" ------- Key Bindings -------

" F3 to toggle terminal from anywhere / any mode; adds ESC
" and C-w window-switching to terminal mode.
nnoremap <F3> :Ttoggle<cr><C-w><C-w>A
nnoremap <F4> :Ttoggle<cr><C-w><C-w><C-w>LA
inoremap <F3> <esc>:Ttoggle<cr><C-w><C-w>A
nnoremap <F4> <esc>:Ttoggle<cr><C-w><C-w><C-w>LA
tnoremap <F3> <C-\><C-n>:Ttoggle<cr>
tnoremap <F4> <C-\><C-n>:Ttoggle<cr>
tnoremap <esc> <C-\><C-n>
tnoremap <C-w><C-w> <C-\><C-n><C-w><C-w>

" Kill the damned Ex mode.
nnoremap Q <nop>

" Bind <leader>
let mapleader = ","
let g:mapleader = ","

" Open file prompt with current path
nmap <leader>e :e <C-R>=expand("%:p:h") . '/'<CR>

" Show undo tree
nmap <silent> <leader>u :MundoToggle<CR>

" Show NERDTree
nmap <silent> <leader>t <ESC>:NERDTreeToggle<CR>

""nmap <silent> <C-k> <Plug>(ale_previous_wrap)
""nmap <silent> <C-j> <Plug>(ale_next_wrap)

" --- Filetype-specific bindings ---

" JS + Flow
autocmd FileType javascript nnoremap <buffer> <silent> <F2> :FlowType<CR>
autocmd FileType javascript nnoremap <buffer> <silent> <leader>r :FlowType<CR>


set wrap
" Hanging indent soft-wrap
set breakindent
set breakindentopt=shift:2

" Avoid line-wrapping in the middle of a word.
set lbr
