" TODO: Try
" Neovim configs (including statusbar): https://github.com/phaazon/config/tree/master/nvim
" Neovim LSP config: https://www.reddit.com/r/neovim/comments/krghi3/why_neovim_lsp_client_by_tj/giaa72y/
" ... with https://github.com/RishabhRD/nvim-lsputils
" ... or coc.nvim
" ... or this with its recommendations in the thread: https://twitter.com/acid2/status/1358064739650273281
" Neovim 0.5 LSP support
" https://github.com/terryma/vim-multiple-cursors
" https://github.com/nathanaelkane/vim-indent-guides or listchars (https://imgur.com/a/FiHC9Dy)
" https://github.com/Roguelazer/neovim-fuzzy (from https://www.roguelazer.com/2019/04/vim-setup-2019/)
" lightline, with settings from above.
"   And https://www.reddit.com/r/vim/comments/45xk60/as_vimairline_got_heavier_i_switched_to/
"   https://github.com/johncf/devenv/blob/002baa5/config/nvim/base/plugin-opts.vim#L1-L96
" https://github.com/tpope/vim-surround
" https://github.com/tpope/vim-obsession
" https://github.com/dhruvasagar/vim-prosession
" tpope/vim-abolish
" https://github.com/tpope/vim-fugitive
" https://github.com/markonm/traces.vim
" https://github.com/airblade/vim-rooter
" https://github.com/ycm-core/YouCompleteMe
" https://prettier.io/docs/en/vim.html
" https://github.com/dense-analysis/ale for eslint et al...?
" 'exrc' with 'secure' for project-level .vimrc
"   " Omnicomplete settings
"   "filetype plugin on
"   "set omnifunc=LanguageClient#textDocument_completion()
" https://www.reddit.com/r/neovim/comments/3oeko4/post_your_fzfvim_configurations/
" https://github.com/zenbro/dotfiles/blob/master/.nvimrc#L151-L187 ...?
" https://statico.github.io/vim3.html ...?

" TODO: airline

" vim-plug {{{
call plug#begin('~/.vim/plugged')

" A bunch of, uh, 'sensible' defaults.
Plug 'tpope/vim-sensible', { 'commit': '5dc6eb2' }

" A pair of commands (Sayonara + ...ra!) that handle both buffer deletion and window-closing.
"Plug 'mhinz/vim-sayonara'

" Colorschemes
Plug 'damncabbage/fairyfloss.vim' " Forked from tssm original; unfixed colour typo.

" Files
Plug 'scrooloose/nerdtree'
"Plug 'dhruvasagar/vim-vinegar' " vim-vinegar for NERDTree

" Undo graph
Plug 'mbbill/undotree'

" Session management
Plug 'tpope/vim-obsession'
"Plug 'dhruvasagar/vim-prosession' " NOTE: depends on vim-obsession

" Language Support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Generic tabbing
Plug 'ervandew/supertab'

" Multi-entry selection UI for both files and LanguageClient
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" JSON
Plug 'elzr/vim-json', { 'for': 'json' }

" JS
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }

" Typescript
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'javascript.jsx', 'typescript'] }
" TODO: Try:
" \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'yaml'] }
" Because it's a little obnoxious with how it sets up Prettier.
if hasmapto('<leader>p')
  nunmap <buffer> <leader>p
endif

" Ruby
Plug 'thoughtbot/vim-rspec', { 'for': ['ruby'] }

" Elixir
Plug 'elixir-editors/vim-elixir'

" Markdown
Plug 'godlygeek/tabular' " eg. :Tab /,\zs  - must come *before* vim-markdown
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

" Writing
Plug 'junegunn/goyo.vim', { 'for': ['markdown', 'text'] }

" Initialize plugin system
call plug#end()
" }}}


" Prelude {{{

" Force sensible to load in, so we can override parts of it.
runtime! plugin/sensible.vim

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup END

" Set <leader> to comma for all shortcuts.
let mapleader = ","
let g:mapleader = ","
set tm=2000 " Leader key timeout
" Allow the normal use of "," by pressing it twice.
noremap ,, ,

" Kill the damned Ex mode.
nnoremap Q <nop>

" Have :q do a combo of bdelete + close window, and :wq write then do the same.
"cnoreabbrev wq  w<bar>Sayonara
"cnoreabbrev  q!       q!
"cnoreabbrev  q        Sayonara

" Write without auto-formatters or other autocommand-driven actions.
command! W :noautocmd write

" }}}


" Shell {{{

" Load in aliases+functions to make them available in a :!... command.
let $BASH_ENV = "~/.vim/bash.sh"

" }}}


" Files, Backups and Undo {{{

set nobackup

set undofile " Persist undo records.
set undodir=~/.vim/undodir
nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_WindowLayout = 3
let g:undotree_SetFocusWhenToggle = 1

" Return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
set viminfo^=% " Remember info about open buffers on close

" }}}


" Visual {{{

set t_Co=256 " Say we can use 256 colours
set termguicolors " Use the hex-code colours in colour-schemes (24-bit colours).

colorscheme fairyfloss
"hi Underlined guifg=#ffffff guibg=NONE gui=underline cterm=none ctermfg=0

" Use visible search highlighting
hi Search ctermfg=white ctermbg=173 cterm=none guifg=#ffffff guibg=#e5786d gui=none
hi! link Visual Search

" Fix up the lack of Spell* and Pmenu* styles (which LanguageClient uses) by copying SpellBad.
hi SpellBad   ctermbg=NONE guifg=NONE guibg=NONE gui=undercurl
hi SpellCap   ctermbg=NONE guifg=NONE guibg=NONE gui=undercurl
hi SpellLocal ctermbg=NONE guifg=NONE guibg=NONE gui=undercurl
hi SpellRare  ctermbg=NONE guifg=NONE guibg=NONE gui=undercurl
hi Pmenu      ctermfg=0 ctermbg=13 guifg=fg guibg=Grey40
hi PmenuThumb ctermbg=15 guibg=Black

" Show trailing whitespace
highlight default BadWhitespace ctermbg=red guibg=red
autocmd ColorScheme <buffer> highlight default BadWhitespace ctermbg=red guibg=red
match BadWhitespace /\s\+$/

" Show tabs and nbsp, extends+precedes for no-wrapping buffers. (TODO: trail:\❡, maybe)
set listchars=tab:⇛\ ,extends:→,precedes:→,nbsp:\◦
set list

" Different background at the 85-column mark characters
let &colorcolumn=85
highlight ColorColumn ctermbg=235 guifg=fg guibg=#595272
" To highlight from 85 onwards instead, use: let &colorcolumn=join(range(85,999),",")

" }}}


" Intra-buffer search {{{

set noincsearch
set hlsearch

" Highlight word at cursor without changing position
map <silent> <Leader>h :
  \:let view=winsaveview()<CR>
  \*
  \:call winrestview(view)<CR>

" Search for selected text (in visual mode), forwards or backwards, using the
" usual * and # keys.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" }}}


" Selection {{{

" Avoid pastes replacing the yanked text in the default register:
vnoremap <leader>p "_dP

" }}}


" Folding and outlining {{{
set nofoldenable
" }}}


" File-search / file opening {{{

" Open file prompt with current path
nmap <leader>e :e <C-R>=expand("%:p:h") . '/'<CR>

set wildmenu
set wildmode=list:longest,full " Tab-complete files up to longest unambiguous prefix
set wildignore+=*.swp,*.swo

""" FZF
let g:fzf_history_dir = '~/.local/share/fzf-history'

command! FzfModifiedOnBranch call fzf#run({
\   'source': 'git-files-modified-on-branch',
\   'sink': 'edit',
\   'options': '-m +s --prompt="GitBranch> " --preview ''(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500''',
\   'down': '40%'
\ })
" Search files (names), file contents, buffers ...
nnoremap <silent> <C-P> :Files<CR>
nnoremap <silent> <C-K> :Rg<CR>
nnoremap <silent> <leader>b :Buffers<CR>
" ... commits and <file-in-current-buffer>-commits.
nnoremap <silent> <leader>gcc :Commits<CR>
nnoremap <silent> <leader>gbc :BCommits<CR>
map <Leader>m :GFiles?<CR>
map <Leader>M :FzfModifiedOnBranch<CR>
map <Leader>d :Files %:h<CR>

augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END
" TODO: https://github.com/zenbro/dotfiles/blob/master/.nvimrc#L151-L187


""" NERDTree
let NERDTreeHijackNetrw=1
let NERDTreeRespectWildIgnore=0
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1 " Close nerdtree after a file is selected

function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction
function! ToggleFindNerd()
  if IsNERDTreeOpen()
    exec ':NERDTreeToggle'
  else
    exec ':NERDTreeFind'
  endif
endfunction

" If NERDTree is closed, find current file, if open, close it
nmap <silent> <leader>f <ESC>:call ToggleFindNerd()<CR>
nmap <silent> <leader>F <ESC>:NERDTreeToggle<CR>

" A little bit of vim-vinegar, but tied to NERDTree.
function! s:vinegarette()
  let fname = expand('%:t')
  edit %:h
  normal! gg
  call search('\<'.fname.'\>')
endfunction
nnoremap - :<C-U>call <SID>vinegarette()<CR>

" }}}


" Line-wrapping {{{

set linebreak   " Avoid line-wrapping in the middle of a word.
set breakindent " Hanging indent soft-wrap ...
set sbr=↪\      " ... prefixed by an arrow, and a space (to make it line up with a match 2-space indent).
set breakindentopt=min:20,shift:0

" }}}


" Autocomplete {{{

set completeopt+=longest
let g:SuperTabDefaultCompletionType = '<c-x><c-p>' " Use buffer words as default tab completion

" }}}


" Buffers and Tabs {{{

" Keep some space at the bottom of the window
set scrolloff=2

" Tab-shifting
nnoremap mt :tabmove +1<cr>
nnoremap mT :tabmove -1<cr>

function! CloseHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'buflisted(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bdelete' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
command! CloseHiddenBuffers :call CloseHiddenBuffers()

" }}}


" Language-server {{{

" Required for operations modifying multiple buffers like rename.
set hidden " Set a buffer hidden when abandoned.

" TODO:
"set signcolumn=yes " Stop the jarring sign column pop-in/out by keeping the sign column on at all times.

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['flow', 'lsp'],
    \ 'javascript.jsx': ['flow', 'lsp'],
    \ 'typescript': ['typescript-language-server', '--stdio'],
    \ 'typescript.tsx': ['typescript-language-server', '--stdio'],
    \ 'python': ['pyls'],
    \ 'ruby': ['solargraph', 'stdio'],
    \ 'elixir': ['~/build/elixir/ls/language_server.sh'],
    \ }
" The above needs to have:
"   npm install -g typescript-language-server
"   gem install solargraph
"   pip install python-language-server
"   rustup component add rls --toolchain stable-x86_64-apple-darwin

" Check the type under cursor
nnoremap <silent> <leader>t :call LanguageClient_textDocument_hover()<CR>

" References and Implementations under cursor
nnoremap <silent> <leader>r :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <leader>i :call LanguageClient#textDocument_implementation()<CR>

" Show the menu of actions
nnoremap <silent> <leader>o :call LanguageClient_contextMenu()<CR>

" TODO: completion

" Until LanguageClient plugin supports adding to the tag-stack, use this as a workaround
" from a comment on an issue thread:
"   https://github.com/autozimu/LanguageClient-neovim/issues/517#issuecomment-507564489
" instead of just:
"   nnoremap <silent> <leader>T :call LanguageClient_textDocument_definition()<CR>
function! MyGoToDefinition(...) abort
  " Get the current position
  let l:fname = expand('%:p')
  let l:line = line(".")
  let l:col = col(".")
  let l:word = expand("<cword>")

  " Call the original function to jump to the definition
  let l:result = LanguageClient_runSync(
                  \ 'LanguageClient#textDocument_definition', {
                  \ 'handle': v:true,
                  \ })

  " Get the position of definition
  let l:jump_fname = expand('%:p')
  let l:jump_line = line(".")
  let l:jump_col = col(".")

  " If the position is the same as previous, ignore the jump action
  if l:fname == l:jump_fname && l:line == l:jump_line
    return
  endif

  " Workaround: Jump to original file. If the function is in rust, there is a
  " way to ignore the behaviour
  if &modified
    exec 'hide edit'  l:fname
  else
    exec 'edit' l:fname
  endif
  call cursor(l:line, l:col)

  " Store the original setting
  let l:ori_wildignore = &wildignore
  let l:ori_tags = &tags

  " Write a temp tags file
  let l:temp_tags_fname = tempname()
  let l:temp_tags_content = printf("%s\t%s\t%s", l:word, l:jump_fname,
      \ printf("call cursor(%d, %d)", l:jump_line, l:jump_col+1))
  call writefile([l:temp_tags_content], l:temp_tags_fname)

  " Set temporary new setting
  set wildignore=
  let &tags = l:temp_tags_fname

  " Add to new stack
  execute ":tjump " . l:word

  " Restore original setting
  let &tags = l:ori_tags
  let &wildignore = l:ori_wildignore

  " Remove temporary file
  if filereadable(l:temp_tags_fname)
    call delete(l:temp_tags_fname, "rf")
  endif
endfunction
nnoremap <silent> <leader>g :call MyGoToDefinition()<cr>

"let g:LanguageClient_diagnosticsSignsMax = 0
"let g:LanguageClient_diagnosticsEnable = 1
"let g:LanguageClient_useVirtualText = 0

" TODO:
"nnoremap <F5> :call LanguageClient_contextMenu()<CR>
"" Or map each action separately
"nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
"nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
"nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" }}}


" Per-filetype settings {{{

""" Defaults
set expandtab " tab -> space
set shiftwidth=2
set tabstop=2
" TODO: set smarttab?

""" Indentation
" Selectively disable indentexpr for some filetypes.
function! DisableIndent()
  set indentexpr&
endfunction
autocmd FileType markdown call DisableIndent()

""" Formatting
" Disable automatic formatting by default; only turn it on for JS-esque files.
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx Prettier
nmap <leader>lp <Plug>(Prettier)

""" Makefiles
autocmd filetype make setlocal noexpandtab

""" Markdown
au FileType markdown setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

""" Ruby
" Run nearest spec under cursor.
au FileType ruby setlocal nosmarttab
let g:rspec_command = "!bundle exec rspec {spec}"
nnoremap <leader>sr :call RunNearestSpec()<CR>
nnoremap <leader>ss :call RunNearestSpec()<CR>
nnoremap <leader>sf :call RunCurrentSpecFile()<CR>
nnoremap <leader>sl :call RunLastSpec()<CR>

""" Elm
au FileType elm setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4

""" Elixir
au FileType elixir setlocal nosmarttab

""" JSON
let g:vim_json_syntax_conceal = 0

""" JS
au FileType javascript setlocal nosmarttab formatprg='prettier'
let g:jsx_ext_required = 0 " Allow JSX in normal JS files
augroup FiletypeGroup
  autocmd!
  au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END
au FileType javascript.jsx setlocal nosmarttab formatprg='prettier'

""" TS
au BufNewFile,BufRead *.ts setlocal filetype=typescript
au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx

" }}}


" {{{ Obsession/Prosession Session Management
nnoremap <leader>w :Obsess<CR>
nnoremap <leader>W :Obsess!<CR>
" }}}


" {{{ Distraction-Free Writing (Goyo/Zen)
let g:goyo_width = 110
" }}}
